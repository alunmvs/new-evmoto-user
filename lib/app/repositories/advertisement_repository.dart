import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/advertisement_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class AdvertisementRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<Advertisement>> getAdvertisementList({
    required int? type,
    required double? lat,
    required double? lon,
    required int? language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/activity/base/advertisement/queryByType";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var formData = FormData.fromMap({
        "lat": lat,
        "lon": lon,
        "language": language,
        "type": type,
      });

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      print(response.data);

      var advertisementList = <Advertisement>[];

      for (var advertisement in response.data['data']) {
        advertisementList.add(Advertisement.fromJson(advertisement));
      }

      return advertisementList;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
