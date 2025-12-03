import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_evmoto_user/app/data/user_info_model.dart';
import 'package:new_evmoto_user/main.dart';

class UserRepository {
  Future<UserInfo> getUserInfo({int? language}) async {
    try {
      var url = "$baseUrl/user/api/user/queryUserInfo";

      var formData = FormData.fromMap({"language": language});

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = Dio();
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
}
