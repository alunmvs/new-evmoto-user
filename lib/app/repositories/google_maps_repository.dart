import 'package:dio/dio.dart';
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
        queryParameters: {"query": query, "language": "en", "key": ""},
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
}
