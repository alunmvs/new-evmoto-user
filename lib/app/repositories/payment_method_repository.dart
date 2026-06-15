import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/payment_method_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/environment.dart';

class PaymentMethodRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<PaymentMethod>> getPaymentMethodList() async {
    try {
      var url = "$baseUrl/businessProcess/api/payment/methods";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(url, options: Options(headers: headers));

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      var paymentMethodList = <PaymentMethod>[];
      for (var paymentMethod in response.data['data']) {
        paymentMethodList.add(PaymentMethod.fromJson(paymentMethod));
      }

      return paymentMethodList;
    } on DioException {
      rethrow;
    }
  }
}
