import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/environment.dart';

class DriverNearbyRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  Future<List<DriverNearby>> getDriverNearbyList({
    required double? lat,
    required double? lon,
  }) async {
    try {
      var url = "$baseUrl/orderServer/api/order/nearbyDrivers";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(
        url,
        options: Options(headers: headers),
        queryParameters: {"lat": lat, "lon": lon},
      );

      var result = <DriverNearby>[];

      for (var driverNearby in response.data['data']) {
        result.add(DriverNearby.fromJson(driverNearby));
      }

      return result;
    } on DioException {
      rethrow;
    }
  }
}
