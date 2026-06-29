import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/app/utils/geocoding_cache_options.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  late final CacheStore cacheStore;
  late final CacheOptions geocodingReverseCacheOptions;
  late final CacheOptions geocodingPlacesCacheOptions;

  final languageServices = Get.find<LanguageServices>();

  final deviceId = "".obs;
  final packageVersion = "".obs;
  final buildNumber = "".obs;

  bool isLoggingOut = false;
  bool _isInitialized = false;
  final _pendingCancelTokens = <CancelToken>[];

  void beginLogout() {
    if (isLoggingOut) return;
    isLoggingOut = true;
    for (final token in List<CancelToken>.from(_pendingCancelTokens)) {
      if (!token.isCancelled) {
        token.cancel('logout');
      }
    }
    _pendingCancelTokens.clear();
  }

  void endLogout() {
    isLoggingOut = false;
  }

  void _removeCancelToken(CancelToken? token) {
    if (token != null) {
      _pendingCancelTokens.remove(token);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await manualOnInit();
  }

  Future<void> manualOnInit() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await Future.wait([getPackageInfo(), getDeviceId(), _initCacheStore()]);

    geocodingReverseCacheOptions = GeocodingCacheOptions.reverseGeocoding(
      cacheStore,
    );
    geocodingPlacesCacheOptions = GeocodingCacheOptions.placesSearch(
      cacheStore,
    );

    dio.interceptors.insert(
      0,
      DioCacheInterceptor(
        options: CacheOptions(store: cacheStore, policy: CachePolicy.noCache),
      ),
    );

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //       client.findProxy = (uri) {
    //         return "PROXY 192.168.0.146:8888";
    //       };

    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    //       return client;
    //     };

    dio.interceptors.add(
      CurlLoggingInterceptor(showRequestLog: false, showResponseLog: false),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['version'] = packageVersion.value;
          options.headers['deviceid'] = deviceId.value;
          options.headers['timestamp'] = DateTime.now().millisecondsSinceEpoch
              .toString();
          options.headers['from'] = Platform.isAndroid
              ? "android"
              : Platform.isIOS
              ? "ios"
              : "others";
          options.headers['role'] = "user";
          options.headers['nonce'] = generateMd5Timestamp();

          final cancelToken = CancelToken();
          options.cancelToken = cancelToken;
          _pendingCancelTokens.add(cancelToken);

          return handler.next(options);
        },
        onError: (error, handler) {
          _removeCancelToken(error.requestOptions.cancelToken);

          if (isLoggingOut) {
            return handler.next(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: DioExceptionType.cancel,
                error: '',
              ),
            );
          }
          // Debug Error
          // print("request API base URL ${error.requestOptions.uri.path}");

          final Map<String, dynamic> dataMap = {};
          if (error.requestOptions.data is FormData) {
            final formData = error.requestOptions.data as FormData;
            for (var field in formData.fields) {
              dataMap[field.key] = field.value;
            }
            for (var file in formData.files) {
              dataMap[file.key] = file.value.filename;
            }
            // print("request API data $dataMap");
          }

          // print("response API ${error.response?.data}");

          // Override Error
          String customMessage;

          switch (error.type) {
            case DioExceptionType.connectionError:
              customMessage =
                  languageServices.language.value.dioExceptionConnectionError ??
                  "-";
              break;

            case DioExceptionType.connectionTimeout:
              customMessage =
                  languageServices
                      .language
                      .value
                      .dioExceptionConnectionTimeout ??
                  "-";
              break;

            case DioExceptionType.receiveTimeout:
              customMessage =
                  languageServices.language.value.dioExceptionReceiveTimeout ??
                  "-";
              break;

            case DioExceptionType.badResponse:
              customMessage =
                  "${languageServices.language.value.dioExceptionBadResponse ?? "-"} (${error.response?.statusCode}).";
              break;

            case DioExceptionType.cancel:
              customMessage =
                  languageServices.language.value.dioExceptionCancel ?? "-";
              break;

            default:
              customMessage =
                  languageServices.language.value.dioExceptionDefault ?? "-";
              // print("ini custom message (default) $customMessage");
              break;
          }

          // print("ini custom message $customMessage");

          // Override error message
          final customError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: customMessage,
          );
          try {
            FirebaseCrashlytics.instance.recordError(
              error,
              error.stackTrace,
              information: [
                error.type,
                error.requestOptions.uri.toString(),
                jsonEncode(error.response?.headers.map),
                dataMap,
                error.response?.data ?? "",
              ],
              printDetails: true,
              fatal: true,
            );
          } catch (e) {}

          handler.next(customError);
        },
        onResponse: (response, handler) async {
          _removeCancelToken(response.requestOptions.cancelToken);

          if (response.data != null) {
            if (response.data is Map<String, dynamic>) {
              if (response.data['code'] == 600) {
                await handleSessionExpired(
                  snackbarText:
                      languageServices.language.value.offlineText ?? "-",
                );
              }
            }
          }

          return handler.next(response);
        },
      ),
    );
  }

  Future<void> _initCacheStore() async {
    final directory = await getApplicationCacheDirectory();
    cacheStore = FileCacheStore('${directory.path}/geocoding_api_cache');
  }

  Future<void> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageVersion.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
  }

  Future<void> getDeviceId() async {
    var storage = FlutterSecureStorage();
    var deviceId = await storage.read(key: "device_id");

    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await storage.write(key: "device_id", value: deviceId);
    }

    this.deviceId.value = deviceId;
  }

  String generateMd5Timestamp() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(timestamp);
    final digest = md5.convert(bytes);

    return digest.toString();
  }
}
