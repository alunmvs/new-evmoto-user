import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class NotificationRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> subscribeNotification({
    required String? fcmToken,
    required String? apnsToken,
    required String deviceType,
    required String? deviceId,
    required String? appVersion,
    required String? osVersion,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/notification/subscribe";

      var formData = FormData.fromMap({
        "fcmToken": fcmToken,
        "apnsToken": apnsToken,
        "deviceType": deviceType,
        "deviceId": deviceId,
        "appVersion": appVersion,
        "osVersion": osVersion,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> unsubscribeNotification({
    required String? fcmToken,
    required String? apnsToken,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/notification/unsubscribe";

      var formData = FormData.fromMap({
        "fcmToken": fcmToken,
        "apnsToken": apnsToken,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      rethrow;
    }
  }
}
