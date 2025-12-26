import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide FormData;
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class CouponRepository {
  final apiServices = Get.find<ApiServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  Future<List<Coupon>> getCouponList({
    int? pageNum,
    int? language,
    int? size,
    int? state,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/activity/api/coupon/queryMyCoupons";

      var formData = FormData.fromMap({
        "pageNum": pageNum,
        "size": size,
        "state": state,
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

      var couponList = <Coupon>[];
      for (var coupon in response.data['data']) {
        couponList.add(Coupon.fromJson(coupon));
      }

      return couponList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<Coupon>> getOrderCouponList({
    String? orderId,
    int? orderType,
    int? pageNum,
    int? language,
    int? size,
    int? state,
  }) async {
    try {
      var url =
          "${firebaseRemoteConfigServices.remoteConfig.getString("user_base_url")}/activity/api/taxi/queryCoupon";

      var formData = FormData.fromMap({
        "orderId": orderId,
        "orderType": orderType,
        "pageNum": pageNum,
        "size": size,
        "language": language,
      });

      var dio = apiServices.dio;
      var response = await dio.post(url, data: formData);

      var couponList = <Coupon>[];
      for (var coupon in response.data['coupon']) {
        couponList.add(Coupon.fromJson(coupon));
      }

      return couponList;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
