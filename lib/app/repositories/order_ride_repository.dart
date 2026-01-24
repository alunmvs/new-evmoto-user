import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/data/models/order_review_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/data/models/requested_order_ride_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class OrderRideRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<OrderRideServer> getOrderRideServerDetail({
    required String orderId,
    required int orderType,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/pushSingle/api/netty/queryOrderServer";

      var formData = FormData.fromMap({
        "language": language,
        "orderId": orderId,
        "orderType": orderType,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return OrderRideServer.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<ActiveOrder>> getActiveOrderList({
    int? language,
    int? pageNum,
    int? size,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/orderServer/api/order/queryServingOrder";

      var formData = FormData.fromMap({
        "language": language,
        "pageNum": pageNum,
        "size": size,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var result = <ActiveOrder>[];

      for (var activeOrder in response.data['data']) {
        result.add(ActiveOrder.fromJson(activeOrder));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<HistoryOrder>> getHistoryOrderList({
    int? language,
    int? pageNum,
    int? size,
    int? type,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/orderServer/api/order/queryMyOrderList";

      var formData = FormData.fromMap({
        "language": language,
        "pageNum": pageNum,
        "size": size,
        "type": type,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var result = <HistoryOrder>[];

      for (var activeOrder in response.data['data']) {
        result.add(HistoryOrder.fromJson(activeOrder));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<OrderRide> getOrderRideDetailbyOrderId({
    String? orderId,
    int? language,
    int? orderType,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/orderServer/api/order/queryOrderInfo";

      var formData = FormData.fromMap({
        "orderId": orderId,
        "orderType": orderType,
        "language": language,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return OrderRide.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<RequestedOrderRide> requestOrderRide({
    int? language,
    int? orderType,
    String? passengersPhone,
    String? startLat,
    String? orderSource,
    String? travelTime,
    String? passengers,
    String? placementLat,
    String? tipMoney,
    String? endLon,
    String? startAddress,
    String? serverCarModelId,
    String? type,
    String? substitute,
    String? endLat,
    String? startLon,
    String? endAddress,
    String? placementLon,
    required double? amount,
    required int? payType,
    required int? couponId,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/businessProcess/api/orderPrivateCar/saveOrderPrivateCar";

      var formData = FormData.fromMap({
        "passengersPhone": passengersPhone,
        "orderType": orderType,
        "startLat": startLat,
        "orderSource": orderSource,
        "travelTime": travelTime,
        "passengers": passengers,
        "placementLat": placementLat,
        "tipMoney": tipMoney,
        "endLon": endLon,
        "startAddress": startAddress,
        "serverCarModelId": serverCarModelId,
        "type": type,
        "substitute": substitute,
        "endLat": endLat,
        "startLon": startLon,
        "endAddress": endAddress,
        "placementLon": placementLon,
        "language": language,
        "amount": amount,
        "payType": payType,
        "couponId": couponId,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return RequestedOrderRide.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<OrderRidePricing>> getOrderRidePricingList({
    String? startLonLat,
    String? endLonLat,
    int? type,
    int? language,
    required int? couponId,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/pricing/base/serverCarModel/queryServerCarModel";

      var formData = FormData.fromMap({
        "startLonLat": startLonLat,
        "endLonLat": endLonLat,
        "type": type,
        "language": language,
        "couponId": couponId,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      var result = <OrderRidePricing>[];

      for (var orderRidePricing in response.data['data']) {
        result.add(OrderRidePricing.fromJson(orderRidePricing));
      }

      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrderRide({
    String? orderId,
    int? orderType,
    int? language,
    String? reason,
    String? remark,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/cancelOrder/api/taxi/addCancle";

      var formData = FormData.fromMap({
        "id": orderId,
        "orderType": orderType,
        "language": language,
        "reason": reason,
        "remark": remark,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> paidOrder({
    required String orderId,
    required int payType,
    required int type,
    required int orderType,
    required int language,
    required int couponId,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/payment/api/taxi/payTaxiOrder";

      var formData = FormData.fromMap({
        "orderId": orderId,
        "payType": payType,
        "type": type,
        "orderType": orderType,
        "language": language,
        "couponId": couponId,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> submitRatingAndReviewOrder({
    required int orderType,
    required String orderId,
    required String? content,
    required double fraction,
    required int language,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/evaluation/api/taxi/orderEvaluate";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
        "content": content,
        "fraction": fraction.toInt(),
        "language": language,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<OrderReview> getOrderReviewDetail({
    required int orderType,
    required String orderId,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/orderServer/api/order/queryOrderReview";

      var formData = FormData.fromMap({
        "orderType": orderType,
        "orderId": orderId,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = apiServices.dio;
      var response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.data['code'] != 200) {
        throw response.data['msg'];
      }

      return OrderReview.fromJson(response.data['data']);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
