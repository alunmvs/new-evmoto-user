import 'package:dio/dio.dart';
import 'package:new_evmoto_user/app/data/agreement_model.dart';
import 'package:new_evmoto_user/main.dart';

class AgreementRepository {
  Future<Agreement> getAgreementDetail({
    int? userType,
    int? language,
    int? type,
  }) async {
    try {
      var url = "$baseUrl/app/base/agreement/queryByType";

      var formData = FormData.fromMap({
        "userType": userType,
        "language": language,
        "type": type,
      });

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      return Agreement.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
