import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart'
    hide Routes;
import 'package:new_evmoto_user/app/data/models/order_review_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/rating_label_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/advanced_booking_cancel_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedBookingDetailController extends GetxController {
  final OrderRideRepository orderRideRepository;
  final OpenMapsRepository openMapsRepository;
  final AdvanceBookingRepository advanceBookingRepository;

  AdvancedBookingDetailController({
    required this.orderRideRepository,
    required this.openMapsRepository,
    required this.advanceBookingRepository,
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
  final id = Rx<int?>(null);

  final advancedBooking = AdvancedBooking().obs;

  final rating = 0.0.obs;
  final ratingLabelList = <RatingLabel>[].obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;
    id.value = Get.arguments['id'];
    try {
      await Future.wait([getAdvancedBookingDetail()]);
      await Future.wait([getOrderRideDetail()]);
      await getRatingLabelList(
        rating:
            orderRideDetail.value.orderScore == 0 ||
                orderRideDetail.value.orderScore == null
            ? 0
            : orderRideDetail.value.orderScore!,
      );
      isFetch.value = false;
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setupGoogleMapOriginToDestination();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getAdvancedBookingDetail() async {
    advancedBooking.value =
        (await advanceBookingRepository.getAdvancedBookingDetail(
          id: id.value,
        )) ??
        AdvancedBooking();
  }

  Future<void> getOrderRideDetail() async {
    if (advancedBooking.value.orderId != null) {
      orderRideDetail.value = (await advanceBookingRepository
          .getOrderRideDetailbyOrderId(bookingId: advancedBooking.value.id));
    }
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
        advancedBooking.value.startLat!,
        advancedBooking.value.startLon!,
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
        advancedBooking.value.endLat!,
        advancedBooking.value.endLon!,
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
      'order_${advancedBooking.value.orderId}_origin_to_destination_direction_cache',
    );

    if (originToDestinationCache == null) {
      direction.value = await openMapsRepository.getDirection(
        originLatitude: advancedBooking.value.startLat.toString(),
        originLongitude: advancedBooking.value.startLon.toString(),
        destinationLatitude: advancedBooking.value.endLat.toString(),
        destinationLongitude: advancedBooking.value.endLon.toString(),
      );
      await prefs.setString(
        'order_${advancedBooking.value.orderId}_origin_to_destination_direction_cache',
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

    var originLatitude = advancedBooking.value.startLat!;
    var originLongitude = advancedBooking.value.startLon!;
    var destinationLatitude = advancedBooking.value.endLat!;
    var destinationLongitude = advancedBooking.value.endLon!;

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

  double getTravelFare() {
    var travelFare = 0.0;

    travelFare += advancedBooking.value.startMoney ?? 0.0;
    travelFare += advancedBooking.value.waitMoney ?? 0.0;
    travelFare += advancedBooking.value.mileageMoney ?? 0.0;
    travelFare += advancedBooking.value.durationMoney ?? 0.0;
    travelFare += advancedBooking.value.longDistanceMoney ?? 0.0;
    travelFare += advancedBooking.value.nightMoney ?? 0.0;
    travelFare += advancedBooking.value.fastigiumMoney ?? 0.0;

    return travelFare;
  }

  double getPromoMoney() {
    var promoMoney = 0.0;
    if (advancedBooking.value.couponMoney != null &&
        advancedBooking.value.couponMoney != 0) {
      promoMoney += advancedBooking.value.couponMoney!;
      return promoMoney;
    }
    promoMoney += advancedBooking.value.discountMoney ?? 0.0;
    return promoMoney;
  }

  bool isAbleCancelAdvanceBooking() {
    var result = false;

    if ([0, 1].contains(advancedBooking.value.state)) {
      result = true;
    }

    if ([2].contains(advancedBooking.value.state)) {
      if ([1, 2, 3, 4].contains(orderRideDetail.value.state)) {
        result = true;
      }
    }

    return result;
  }

  bool isAbleOrderAgainAdvanceBooking() {
    var result = false;

    if ([5, 6].contains(advancedBooking.value.state)) {
      result = true;
    }

    if ([2].contains(advancedBooking.value.state)) {
      if (OrderState.COMPLETED_STATE_LIST.contains(
        orderRideDetail.value.state,
      )) {
        result = true;
      }
    }

    return result;
  }

  Future<void> onTapCancel() async {
    await Get.dialog(
      AdvancedBookingCancelDialog(
        onTapConfirm: () async {
          try {
            await advanceBookingRepository.cancelAdvanceBooking(
              bookingId: advancedBooking.value.id!,
            );
            Get.close(1);
            await Future.wait([getAdvancedBookingDetail()]);
            await Future.wait([getOrderRideDetail()]);
            await getRatingLabelList(
              rating:
                  orderRideDetail.value.orderScore == 0 ||
                      orderRideDetail.value.orderScore == null
                  ? 0
                  : orderRideDetail.value.orderScore!,
            );
          } on DioException catch (e) {
            SnackbarHelper.showSnackbarError(text: e.error.toString());
          } catch (e) {
            if (e.toString().contains("GoogleMapController") == false) {
              SnackbarHelper.showSnackbarError(text: e.toString());
            }
          }
        },
      ),
    );
  }

  Future<void> onTapOrderAgain() async {
    Get.back();
    homeController.indexNavigationBar.value = 0;
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
}
