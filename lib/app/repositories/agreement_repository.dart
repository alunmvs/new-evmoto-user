import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/agreement_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/main.dart';

class AgreementRepository {
  final apiServices = Get.find<ApiServices>();

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

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      return Agreement.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
