import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/deposit_balance_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class PaymentRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<DepositBalance> depositBalance({
    required int language,
    required int payType,
    required double money,
    required int type,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/payment/api/user/depositBalance";

      var formData = FormData.fromMap({
        "language": language,
        "payType": payType,
        "money": money,
        "type": type,
      });

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

      return DepositBalance.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> redirectUrlDepositBalance({
    required String transactionStatus,
    required String statusCode,
    required String orderId,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/payment/base/wxCancelUserBalance";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var formData = FormData.fromMap({
        "transaction_status": transactionStatus,
        "status_code": statusCode,
        "order_id": orderId,
      });

      print(url);
      print(headers);
      print({
        "transaction_status": transactionStatus,
        "status_code": statusCode,
        "order_id": orderId,
      });

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
