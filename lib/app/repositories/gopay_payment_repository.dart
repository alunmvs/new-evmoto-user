import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/gopay_balance_model.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_data_model.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_status_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/environment.dart';

class GopayPaymentRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<GopayLinkData> linkGopay({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      var url = "$baseUrl/account/api/gopay/link";

      var data = {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
      };

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      return GopayLinkData.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<GopayLinkStatus> getGopayLinkStatus() async {
    try {
      var url = "$baseUrl/account/api/gopay/status";

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

      return GopayLinkStatus.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<GopayBalance> getGopayBalance() async {
    try {
      var url = "$baseUrl/account/api/gopay/balance";

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

      return GopayBalance.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<bool> unlinkGopay() async {
    try {
      var url = "$baseUrl/account/api/gopay/unlink";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: {},
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      return true;
    } on DioException {
      rethrow;
    }
  }
}
