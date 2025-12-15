import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/balance_history_consumption_model.dart';
import 'package:new_evmoto_user/app/data/balance_history_deposit_model.dart';
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

  Future<List<BalanceHistoryDeposit>> getBalanceHistoryDeposit({
    required int pageNum,
    required int size,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/user/api/recharge/queryRechargeRecord";

      var formData = FormData.fromMap({
        "language": language,
        "pageNum": pageNum,
        "size": size,
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

      var balanceHistoryDepositList = <BalanceHistoryDeposit>[];

      for (var balanceHistoryDeposit in response.data['data']) {
        balanceHistoryDepositList.add(
          BalanceHistoryDeposit.fromJson(balanceHistoryDeposit),
        );
      }

      return balanceHistoryDepositList;
    } on DioException catch (e) {
      print("balance history list");
      print(e.response!.data);
      rethrow;
    }
  }

  Future<List<BalanceHistoryConsumption>> getBalanceHistoryConsumption({
    required int pageNum,
    required int size,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/orderServer/api/order/queryMyTravelRecord";

      var formData = FormData.fromMap({
        "language": language,
        "pageNum": pageNum,
        "size": size,
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

      var balanceHistoryConsumptionList = <BalanceHistoryConsumption>[];

      for (var balanceHistoryConsumption in response.data['data']) {
        balanceHistoryConsumptionList.add(
          BalanceHistoryConsumption.fromJson(balanceHistoryConsumption),
        );
      }

      return balanceHistoryConsumptionList;
    } on DioException catch (e) {
      print("balance consumption list");
      print(e.response!.data);
      rethrow;
    }
  }
}
