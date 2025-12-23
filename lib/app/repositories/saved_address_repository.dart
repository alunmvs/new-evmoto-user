import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class SavedAddressRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> insertSavedAddress({
    required String addressName,
    required String addressTitle,
    required String addressDetail,
    required String latitude,
    required String longitude,
    required int addressType,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/user/address";

      var data = {
        "addressName": addressName,
        "addressTitle": addressTitle,
        "addressDetail": addressDetail,
        "latitude": latitude,
        "longitude": longitude,
        "addressType": addressType,
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

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<SavedAddress>> getSavedAddressList() async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/account/user/address";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(url, options: Options(headers: headers));

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var savedAddressList = <SavedAddress>[].obs;

      for (var savedAddress in response.data['data']) {
        savedAddressList.add(SavedAddress.fromJson(savedAddress));
      }

      return savedAddressList;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
