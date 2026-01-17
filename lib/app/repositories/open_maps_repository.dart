import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class OpenMapsRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<OpenMapDirection> getDirection({
    String? originLatitude,
    String? originLongitude,
    String? destinationLatitude,
    String? destinationLongitude,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/businessProcess/api/osrm/route/v1/driving/$originLongitude,$originLatitude;$destinationLongitude,$destinationLatitude";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {'Authorization': "Bearer $token"};

      var dio = apiServices.dio;
      var response = await dio.get(
        url,
        options: Options(headers: headers),
        queryParameters: {"overview": "full", "geometries": "geojson"},
      );

      return OpenMapDirection.fromJson(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
