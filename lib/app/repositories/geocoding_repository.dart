import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_with_points_model.dart';
import 'package:new_evmoto_user/app/data/models/recommendation_access_point_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/utils/geocoding_cache_options.dart';
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
        options: apiServices.geocodingReverseCacheOptions.toOptions().copyWith(
          headers: headers,
        ),
        queryParameters: {
          // "lat": GeocodingCacheOptions.quantizeCoordinate(latitude),
          // "lng": GeocodingCacheOptions.quantizeCoordinate(longitude),
          "lat": latitude,
          "lng": longitude,
        },
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

      var normalizedQuery = GeocodingCacheOptions.normalizeQuery(query);
      var requestOptions =
          GeocodingCacheOptions.shouldCachePlacesQuery(normalizedQuery)
          ? apiServices.geocodingPlacesCacheOptions.toOptions().copyWith(
              headers: headers,
            )
          : Options(headers: headers);

      var response = await dio.get(
        url,
        options: requestOptions,
        queryParameters: {
          "query": normalizedQuery,
          "limit": limit,
          "lat": locationServices.currentLatitude.value,
          "lng": locationServices.currentLongitude.value,
          "language": languageServices.languageGeocoding.value,
        },
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

  Future<List<GeocodingPlaceWithPoints>> searchGeocodingPlacesByQuery({
    String? query,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/geocoding/searchWithPoints";

      var dio = apiServices.dio;

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var normalizedQuery = GeocodingCacheOptions.normalizeQuery(query);

      var response = await dio.post(
        url,
        options: Options(headers: headers),
        data: {
          "query": normalizedQuery,
          "lat": locationServices.currentLatitude.value,
          "lng": locationServices.currentLongitude.value,
        },
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      var geocodingPlaceList = <GeocodingPlaceWithPoints>[];
      final results = response.data['data']?['results'];

      if (results is Iterable<dynamic>) {
        for (var geocodingPlace in results) {
          geocodingPlaceList.add(
            GeocodingPlaceWithPoints.fromJson(
              Map<String, dynamic>.from(geocodingPlace),
            ),
          );
        }
      }

      return geocodingPlaceList;
    } on DioException {
      rethrow;
    }
  }

  Future<List<GeocodingPlaceWithPoints>>
  getGeocodingDestinationPointCandidates({
    required double? latitude,
    required double? longitude,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/geocoding/destinationPoint";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        options: Options(headers: headers),
        data: {"lat": latitude, "lng": longitude},
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      var candidateList = <GeocodingPlaceWithPoints>[];
      final candidates = response.data['data']?['candidates'];

      if (candidates is Iterable<dynamic>) {
        for (var candidate in candidates) {
          candidateList.add(
            GeocodingPlaceWithPoints.fromJson(
              Map<String, dynamic>.from(candidate),
            ),
          );
        }
      }

      return candidateList;
    } on DioException {
      rethrow;
    }
  }

  Future<RecommendationAccessPoint?> getRecommendAccessPoint({
    required double? latitude,
    required double? longitude,
  }) async {
    try {
      var url = "$baseUrl/businessProcess/api/geocoding/recommend-access-point";

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

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      return RecommendationAccessPoint.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }
}
