import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  final deviceId = "".obs;
  final packageVersion = "".obs;
  final buildNumber = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.wait([getPackageInfo(), getDeviceId()]);
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //       client.findProxy = (uri) {
    //         return "PROXY 192.168.18.106:8888";
    //       };

    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    //       return client;
    //     };

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
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.data != null) {
            if (response.data is Map<String, dynamic>) {
              if (response.data['code'] == 600) {
                if (Get.currentRoute != Routes.LOGIN_REGISTER) {
                  var storage = FlutterSecureStorage();
                  await storage.delete(key: 'token');
                  Get.offAllNamed(Routes.LOGIN_REGISTER);
                }
              }
            }
          }

          return handler.next(response);
        },
      ),
    );
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
