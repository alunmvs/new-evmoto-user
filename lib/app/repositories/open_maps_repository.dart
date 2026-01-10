import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';

class OpenMapsRepository {
  final apiServices = Get.find<ApiServices>();

  Future<OpenMapDirection> getDirection({
    String? originLatitude,
    String? originLongitude,
    String? destinationLatitude,
    String? destinationLongitude,
  }) async {
    try {
      var url =
          "https://router.project-osrm.org/route/v1/driving/$originLongitude,$originLatitude;$destinationLongitude,$destinationLatitude";

      var dio = apiServices.dio;
      var response = await dio.get(
        url,
        queryParameters: {"overview": "full", "geometries": "geojson"},
      );

      return OpenMapDirection.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
