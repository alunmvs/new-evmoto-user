import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/environment.dart';

class GeocodingRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  Future<GeocodingAddress?> getAddressByLatitudeLongitude({
    required double? latitude,
    required double? longitude,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/geocoding/reverse";

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
        queryParameters: {"lat": latitude, "lng": longitude},
      );

      return GeocodingAddress.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<List<GeocodingPlace>> getGeocodingPlaceByQuery({
    String? query,
    int? limit,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/geocoding/places";

      var dio = apiServices.dio;

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.get(
        url,
        queryParameters: {
          "query": query,
          "limit": limit,
          "lat": locationServices.currentLatitude.value,
          "lng": locationServices.currentLongitude.value,
          "language": languageServices.languageGeocoding.value,
        },
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      var geocodingPlaceList = <GeocodingPlace>[];

      if (response.data['data'] is Iterable<dynamic>) {
        for (var geocodingPlace in response.data['data']) {
          geocodingPlaceList.add(GeocodingPlace.fromJson(geocodingPlace));
        }
      }

      return geocodingPlaceList;
    } on DioException {
      rethrow;
    }
  }
}
