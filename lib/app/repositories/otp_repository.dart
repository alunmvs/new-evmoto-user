import 'package:dio/dio.dart';
import 'package:new_evmoto_user/main.dart';

class OtpRepository {
  Future<void> requestOTP({String? phone, int? language, int? type}) async {
    try {
      var url = "$baseUrl/account/base/queryCaptcha";

      var formData = FormData.fromMap({
        "phone": phone,
        "language": language,
        "type": type,
      });

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
