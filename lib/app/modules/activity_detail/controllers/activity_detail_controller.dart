import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart';
import 'package:new_evmoto_user/app/data/models/order_review_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/rating_label_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart' as app_pages;

class ActivityDetailController extends GetxController {
  final OrderRideRepository orderRideRepository;
  final OpenMapsRepository openMapsRepository;

  ActivityDetailController({
    required this.orderRideRepository,
    required this.openMapsRepository,
  });

  final formGroup = FormGroup({
    "review": FormControl<String>(validators: <Validator>[]),
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final homeController = Get.find<HomeController>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;
  final direction = OpenMapDirection().obs;

  final orderRideDetail = OrderRide().obs;
  final orderReviewDetail = OrderReview().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  final rating = 0.0.obs;
  final ratingLabelList = <RatingLabel>[].obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;
    try {
      await Future.wait([getOrderRideDetail(), getOrderReviewDetail()]);
      await getRatingLabelList(
        rating:
            orderRideDetail.value.orderScore == 0 ||
                orderRideDetail.value.orderScore == null
            ? 0
            : orderRideDetail.value.orderScore!,
      );
      isFetch.value = false;
      await setupGoogleMapOriginToDestination();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
      isCriticalError.value = true;
      isFetch.value = false;
    } catch (e) {
      if (e.toString().contains("GoogleMapController") == false) {
        SnackbarHelper.showSnackbarError(text: e.toString());
        isCriticalError.value = true;
        isFetch.value = false;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getRatingLabelList({required int rating}) async {
    var ratingLabelConfiguration = jsonDecode(
      firebaseRemoteConfigServices.remoteConfig.getString(
        'user_order_rating_label',
      ),
    );

    ratingLabelList.value = [];
    if ((orderRideDetail.value.orderScore == null ||
            orderRideDetail.value.orderScore == 0) &&
        orderRideDetail.value.state != 10) {
      for (var ratingLabel
          in ratingLabelConfiguration[languageServices
                  .languageCode
                  .value]?['rate_${rating.toInt()}'] ??
              []) {
        ratingLabelList.add(RatingLabel.fromJson(ratingLabel));
      }
    } else {
      for (var ratingLabel
          in ratingLabelConfiguration[languageServices
                  .languageCode
                  .value]?['rate_${rating.toInt()}'] ??
              []) {
        for (var ratingLabelId in orderRideDetail.value.ratingLabels ?? []) {
          if (ratingLabelId == ratingLabel['id']) {
            var selectedRatingLabel = RatingLabel.fromJson(ratingLabel);
            selectedRatingLabel.isSelected = true;
            ratingLabelList.add(selectedRatingLabel);
          }
        }
      }
    }
  }

  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          orderId: orderId.value,
          orderType: orderType.value,
        ));
  }

  Future<void> getOrderReviewDetail() async {
    orderReviewDetail.value = (await orderRideRepository.getOrderReviewDetail(
      orderId: orderId.value,
      orderType: orderType.value,
    ));
  }

  Future<void> setupGoogleMapOriginToDestination() async {
    if (isClosed) return;
    polylines.clear();

    markers.value = markers
        .where((m) => m.markerId != MarkerId('appointment_origin'))
        .toSet();

    var markerId = MarkerId("origin");
    var newMarker = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(
        orderRideDetail.value.startLat!,
        orderRideDetail.value.startLon!,
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_green.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("destination");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderRideDetail.value.endLat!,
        orderRideDetail.value.endLon!,
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_red.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    var prefs = await SharedPreferences.getInstance();

    var originToDestinationCache = prefs.getString(
      'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
    );

    if (originToDestinationCache == null) {
      direction.value = await openMapsRepository.getDirection(
        originLatitude: orderRideDetail.value.startLat.toString(),
        originLongitude: orderRideDetail.value.startLon.toString(),
        destinationLatitude: orderRideDetail.value.endLat.toString(),
        destinationLongitude: orderRideDetail.value.endLon.toString(),
      );
      await prefs.setString(
        'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
        jsonEncode(direction.value.toJson()),
      );
    } else {
      direction.value = OpenMapDirection.fromJson(
        jsonDecode(originToDestinationCache),
      );
    }

    var polylineCoordinates = direction
        .value
        .routes!
        .first
        .geometry!
        .coordinates!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    polylinesCoordinate.value = polylineCoordinates;

    polylines.clear();
    isFetch.value = true;
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF4DABF5),
        width: 6,
      ),
    );
    isFetch.value = false;
    polylines.refresh();

    LatLngBounds bounds;

    var originLatitude = orderRideDetail.value.startLat!;
    var originLongitude = orderRideDetail.value.startLon!;
    var destinationLatitude = orderRideDetail.value.endLat!;
    var destinationLongitude = orderRideDetail.value.endLon!;

    if (originLatitude > destinationLatitude &&
        originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, destinationLongitude),
        northeast: LatLng(originLatitude, originLongitude),
      );
    } else if (originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, destinationLongitude),
        northeast: LatLng(destinationLatitude, originLongitude),
      );
    } else if (originLatitude > destinationLatitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, originLongitude),
        northeast: LatLng(originLatitude, destinationLongitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, originLongitude),
        northeast: LatLng(destinationLatitude, destinationLongitude),
      );
    }

    final basePadding = Get.width * 0.1;
    double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
        .abs();
    double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
        .abs();
    double areaFactor = (latDiff + lngDiff) * 80000;
    var dynamicPadding = (basePadding + areaFactor).clamp(0, 50);

    if (isClosed) return;
    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
    );
  }

  void upsertMarker({required Marker newMarker, required MarkerId markerId}) {
    var isNewMarkerExists = markers.any((m) => m.markerId == markerId);

    if (isNewMarkerExists) {
      markers.value = markers
          .map((m) => m.markerId == markerId ? newMarker : m)
          .toSet();
    } else {
      markers.add(newMarker);
    }
  }

  Future<void> onTapOrderAgain() async {
    await homeController.getActiveOrderList();

    if (homeController.isActiveOrderListNotEmpty.value) {
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarOrderNotSuccess ?? "-",
      );
      return;
    }

    await Get.toNamed(
      app_pages.Routes.CREATE_ORDER_RIDE,
      arguments: {
        "origin_address_name": orderRideDetail.value.startAddressName,
        "origin_address": orderRideDetail.value.startAddress,
        "origin_latitude": orderRideDetail.value.startLat.toString(),
        "origin_longitude": orderRideDetail.value.startLon.toString(),
        "destination_address_name": orderRideDetail.value.endAddressName,
        "destination_address": orderRideDetail.value.endAddress,
        "destination_latitude": orderRideDetail.value.endLat.toString(),
        "destination_longitude": orderRideDetail.value.endLon.toString(),
      },
    );
  }

  Future<void> onTapSubmitAndReview() async {
    if (rating.value != 0.0) {
      var ratingLabels = <int>[];

      for (var ratingLabel in ratingLabelList) {
        if (ratingLabel.isSelected == true) {
          ratingLabels.add(ratingLabel.id!);
        }
      }

      await Future.wait([
        orderRideRepository.submitRatingAndReviewOrder(
          orderType: orderType.value,
          orderId: orderId.value,
          content: formGroup.control("review").value,
          fraction: rating.value,
          language: languageServices.languageCodeSystem.value,
          ratingLabels: ratingLabels,
        ),
      ]);

      await Future.wait([getOrderRideDetail(), getOrderReviewDetail()]);
      await getRatingLabelList(rating: orderRideDetail.value.orderScore!);
      SnackbarHelper.showSnackbarSuccess(
        text: languageServices.language.value.successfullyRatingReview ?? "-",
      );
    } else {
      SnackbarHelper.showSnackbarError(text: "Please tap star to rate");
    }
  }

  double getTravelFare() {
    var travelFare = 0.0;

    travelFare += orderRideDetail.value.startMoney ?? 0.0;
    // travelFare += orderRideDetail.value.waitMoney ?? 0.0;
    travelFare += orderRideDetail.value.mileageMoney ?? 0.0;
    travelFare += orderRideDetail.value.durationMoney ?? 0.0;
    travelFare += orderRideDetail.value.longDistanceMoney ?? 0.0;
    travelFare += orderRideDetail.value.nightMoney ?? 0.0;
    travelFare += orderRideDetail.value.fastigiumMoney ?? 0.0;

    return travelFare;
  }

  double getPromoMoney() {
    var promoMoney = 0.0;
    if (orderRideDetail.value.couponMoney != null &&
        orderRideDetail.value.couponMoney != 0) {
      promoMoney += orderRideDetail.value.couponMoney!;
      return promoMoney;
    }
    promoMoney += orderRideDetail.value.discountMoney ?? 0.0;
    return promoMoney;
  }
}
