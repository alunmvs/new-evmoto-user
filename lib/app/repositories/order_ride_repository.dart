import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_evmoto_user/app/data/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/data/requested_order_ride_model.dart';
import 'package:new_evmoto_user/main.dart';

class OrderRideRepository {
  Future<OrderRide> getOrderRideDetailbyOrderId({
    String? orderId,
    int? language,
    int? orderType,
  }) async {
    try {
      var url = "$baseUrl/orderServer/api/order/queryOrderInfo";

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

      var dio = Dio();
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
  }) async {
    try {
      var url =
          "$baseUrl/businessProcess/api/orderPrivateCar/saveOrderPrivateCar";

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
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = Dio();
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
  }) async {
    try {
      var url = "$baseUrl/pricing/base/serverCarModel/queryServerCarModel";

      var formData = FormData.fromMap({
        "startLonLat": startLonLat,
        "endLonLat": endLonLat,
        "type": type,
        "language": language,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = Dio();
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
  }) async {
    try {
      var url = "$baseUrl/cancelOrder/api/taxi/addCancle";

      var formData = FormData.fromMap({
        "id": orderId,
        "orderType": orderType,
        "language": language,
      });

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      var headers = {
        "Content-Type": "multipart/form-data",
        'Authorization': "Bearer $token",
      };

      var dio = Dio();
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
}
