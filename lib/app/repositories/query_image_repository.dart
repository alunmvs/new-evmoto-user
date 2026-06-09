import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/query_image_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/environment.dart';

class QueryImageRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<QueryImage>> getQueryImageList({
    required int type,
    required int usePort,
  }) async {
    try {
      var url = "$baseUrl/app/base/img/queryImgs";

      var data = {"type": type, "usePort": usePort};

      var headers = {"Content-Type": "application/json"};

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

      var queryImageList = <QueryImage>[];

      for (var data in response.data['list']) {
        queryImageList.add(QueryImage.fromJson(data));
      }

      return queryImageList;
    } on DioException {
      rethrow;
    }
  }
}
