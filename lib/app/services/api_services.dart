import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //       client.findProxy = (uri) {
    //         return "PROXY 192.168.18.121:8888";
    //       };

    //       client.badCertificateCallback =
    //           (X509Certificate cert, String host, int port) => true;

    //       return client;
    //     };

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data != null) {
            if (response.data is Map<String, dynamic>) {
              if (response.data['code'] == 600) {
                if (Get.currentRoute != Routes.LOGIN_REGISTER) {
                  var storage = FlutterSecureStorage();
                  await storage.deleteAll();
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
}
