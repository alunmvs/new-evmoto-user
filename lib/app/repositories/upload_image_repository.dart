import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class UploadImageRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

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
