import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class UserRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<UserInfo> getUserInfo({int? language}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/user/api/user/queryUserInfo";

      var formData = FormData.fromMap({"language": language});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return UserInfo.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount({required String otpCode}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/user-state/quit-with-otp";

      var formData = FormData.fromMap({"otp": otpCode});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> updateName({required String name, required int id}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/tUser/updateById";

      var formData = {"name": name, "id": id};

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
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

  Future<void> updateUserInformation({
    required String name,
    required int? genderType,
    required String? avatarUrl,
    required int id,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/tUser/updateById";

      var formData = {
        "name": name,
        "sex": genderType,
        "avatar": avatarUrl,
        "id": id,
      };

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
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
