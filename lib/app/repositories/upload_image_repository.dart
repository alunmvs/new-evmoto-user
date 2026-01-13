import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class UploadImageRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<String> uploadImage({required XFile file}) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("driver_base_url")}/account/base/driver/img/upload";

      var formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: file.name),
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      return response.data["url"];
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadCall({
    required File file,
    required String fileName,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'evmoto_calls/$fileName',
      );

      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadUserAvatar({
    required File file,
    required String fileName,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'evmoto_user_avatar/$fileName',
      );

      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
