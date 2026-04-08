import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/environment.dart';

class SavedAddressRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<void> insertSavedAddress({
    required String addressName,
    required String addressTitle,
    required String addressDetail,
    required String addressNotes,
    required String latitude,
    required String longitude,
    required int addressType,
  }) async {
    try {
      var url = "$baseUrl/account/user/address";

      var data = {
        "addressName": addressName,
        "addressTitle": addressTitle,
        "addressDetail": addressDetail,
        "addressNotes": addressNotes,
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

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }
    } on DioException {
      rethrow;
    }
  }

  Future<void> updateSavedAddress({
    required int id,
    required String addressName,
    required String addressTitle,
    required String addressDetail,
    required String addressNotes,
    required String latitude,
    required String longitude,
    required int addressType,
  }) async {
    try {
      var url = "$baseUrl/account/user/address";

      var data = {
        "id": id,
        "addressName": addressName,
        "addressTitle": addressTitle,
        "addressDetail": addressDetail,
        "addressNotes": addressNotes,
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
      var response = await dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }
    } on DioException {
      rethrow;
    }
  }

  Future<List<SavedAddress>> getSavedAddressList() async {
    try {
      var url = "$baseUrl/account/user/address";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.get(url, options: Options(headers: headers));

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }

      var savedAddressList = <SavedAddress>[].obs;

      for (var savedAddress in response.data['data']) {
        savedAddressList.add(SavedAddress.fromJson(savedAddress));
      }

      return savedAddressList;
    } on DioException {
      rethrow;
    }
  }

  Future<void> deleteSavedAddress({required int id}) async {
    try {
      var url = "$baseUrl/account/user/address/$id";

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "application/json",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.delete(url, options: Options(headers: headers));

      if (response.data['code'] != null && response.data['code'] != 200) {
        if (response.data['msg'] != null) {
          throw response.data['msg'];
        }
      }
    } on DioException {
      rethrow;
    }
  }
}
