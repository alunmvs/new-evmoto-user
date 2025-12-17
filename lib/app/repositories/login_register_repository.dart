import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/login_data_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class LoginRegisterRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<LoginData> loginByOtp({
    String? phone,
    int? language,
    String? code,
    String? lat,
    String? lng,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/base/user/captchaLogin";

      var formData = FormData.fromMap({
        "phone": phone,
        "code": code,
        "lat": lat,
        "lng": lng,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return LoginData.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
