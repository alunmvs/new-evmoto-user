import 'package:dio/dio.dart';
import 'package:new_evmoto_user/app/data/login_data_model.dart';
import 'package:new_evmoto_user/main.dart';

class LoginRegisterRepository {
  Future<LoginData> loginByOtp({
    String? phone,
    int? language,
    String? code,
    String? lat,
    String? lng,
  }) async {
    try {
      var url = "$baseUrl/account/base/user/captchaLogin";

      var formData = FormData.fromMap({
        "phone": phone,
        "code": code,
        "lat": lat,
        "lng": lng,
        "language": language,
      });

      var dio = Dio();
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
