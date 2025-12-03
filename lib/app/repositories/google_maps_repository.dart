import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_evmoto_user/app/data/google_direction_model.dart';
import 'package:new_evmoto_user/app/data/google_geo_code_search_model.dart';
import 'package:new_evmoto_user/app/data/google_place_text_search_model.dart';

class GoogleMapsRepository {
  Future<List<GooglePlaceTextSearch>> getRecommendationPlaceListByTextSearch({
    String? query,
    String? language,
  }) async {
    try {
      var url = "https://maps.googleapis.com/maps/api/place/textsearch/json";

      var dio = Dio();
      var response = await dio.get(
        url,
        queryParameters: {
          "query": query,
          "language": language,
          "key": dotenv.get("GOOGLE_KEY"),
        },
      );

      var result = <GooglePlaceTextSearch>[];

      for (var place in response.data['results']) {
        result.add(GooglePlaceTextSearch.fromJson(place));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<GoogleGeoCodeSearch>>
  getRecommendationPlaceListByLatitudeLongitude({
    String? latitude,
    String? longitude,
    String? language,
  }) async {
    try {
      var url = "https://maps.googleapis.com/maps/api/geocode/json";

      var dio = Dio();
      var response = await dio.get(
        url,
        queryParameters: {
          "latlng": "$latitude,$longitude",
          "language": language,
          "key": dotenv.get("GOOGLE_KEY"),
        },
      );

      var result = <GoogleGeoCodeSearch>[];

      for (var place in response.data['results']) {
        result.add(GoogleGeoCodeSearch.fromJson(place));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<GoogleDirection>> getDirection({
    String? originLatitude,
    String? originLongitude,
    String? destinationLatitude,
    String? destinationLongitude,
    String? region,
  }) async {
    try {
      var url = "https://maps.googleapis.com/maps/api/directions/json";

      var dio = Dio();
      var response = await dio.get(
        url,
        queryParameters: {
          "origin": "$originLatitude,$originLongitude",
          "destination": "$destinationLatitude,$destinationLongitude",
          "language": "en",
          "key": dotenv.get("GOOGLE_KEY"),
        },
      );

      var result = <GoogleDirection>[];

      for (var place in response.data['routes']) {
        result.add(GoogleDirection.fromJson(place));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
