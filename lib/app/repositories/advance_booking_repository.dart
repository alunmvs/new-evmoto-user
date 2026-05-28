import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/environment.dart';

class AdvanceBookingRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final languageServices = Get.find<LanguageServices>();

  Future<void> requestAdvanceBooking({
    String? startLon,
    String? startLat,
    String? startAddress,
    required String? startAddressName,
    String? endLon,
    String? endLat,
    String? endAddress,
    required String? endAddressName,
    String? travelTime,
    String? serverCarModelId,
    required dynamic priceNo,
    int? orderMoney,
    int? payManner,
    required int? payType,
    String? substitute,
    required int? couponId,
    String? placementLat,
    String? placementLon,

    String? passengers,
    String? tipMoney,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/advanceBooking/create";

      var data = {
        "startLon": startLon,
        "startLat": startLat,
        "startAddress": startAddress,
        "startAddressName": startAddressName,
        "endLon": endLon,
        "endLat": endLat,
        "endAddress": endAddress,
        "endAddressName": endAddressName,
        "travelTime": travelTime,
        "serverCarModelIdStr": serverCarModelId,
        "priceNo": priceNo,
        "orderMoney": orderMoney,
        "payManner": payManner,
        "payType": payType,
        "substitute": substitute,
        "passengers": passengers,
        "tipMoney": tipMoney,
        "placementLat": placementLat,
        "placementLon": placementLon,
        "couponId": couponId,
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
    } on DioException {
      rethrow;
    }
  }
}
