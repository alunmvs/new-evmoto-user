import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/order_review_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ActivityDetailController extends GetxController {
  final GoogleMapsRepository googleMapsRepository;
  final OrderRideRepository orderRideRepository;
  final OpenMapsRepository openMapsRepository;

  ActivityDetailController({
    required this.googleMapsRepository,
    required this.orderRideRepository,
    required this.openMapsRepository,
  });

  final formGroup = FormGroup({
    "review": FormControl<String>(validators: <Validator>[]),
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final orderRideDetail = OrderRide().obs;
  final orderReviewDetail = OrderReview().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  final rating = 5.0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;
    await Future.wait([getOrderRideDetail(), getOrderReviewDetail()]);
    isFetch.value = false;
    await setupGoogleMapOriginToDestination();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          language: languageServices.languageCodeSystem.value,
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
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        'assets/icons/icon_origin.svg',
        Size(22.67, 22.67),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("destination");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderRideDetail.value.endLat!,
        orderRideDetail.value.endLon!,
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        'assets/icons/icon_pinpoint.svg',
        Size(27, 31),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    var openMapDirection = await openMapsRepository.getDirection(
      originLatitude: orderRideDetail.value.startLat.toString(),
      originLongitude: orderRideDetail.value.startLon.toString(),
      destinationLatitude: orderRideDetail.value.endLat.toString(),
      destinationLongitude: orderRideDetail.value.endLon.toString(),
    );

    var polylineCoordinates = openMapDirection
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
        color: Color(0XFF37C086),
        width: 6,
      ),
    );
    isFetch.value = false;
    polylines.refresh();

    LatLngBounds bounds;

    var originLatitude = this.orderRideDetail.value.startLat!;
    var originLongitude = this.orderRideDetail.value.startLon!;
    var destinationLatitude = this.orderRideDetail.value.endLat!;
    var destinationLongitude = this.orderRideDetail.value.endLon!;

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
    var activeOrderList = await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    );

    if (activeOrderList.isNotEmpty) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          languageServices.language.value.snackbarOrderNotSuccess ?? "-",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    Get.toNamed(
      Routes.RIDE,
      arguments: {
        "start_address": orderRideDetail.value.startAddress,
        "start_lat": orderRideDetail.value.startLat,
        "start_lon": orderRideDetail.value.startLon,
        "end_address": orderRideDetail.value.endAddress,
        "end_lat": orderRideDetail.value.endLat,
        "end_lon": orderRideDetail.value.endLon,
      },
    );
  }

  Future<void> onTapSubmitAndReview() async {
    if (rating.value != 0.0) {
      await Future.wait([
        orderRideRepository.submitRatingAndReviewOrder(
          orderType: orderType.value,
          orderId: orderId.value,
          content: formGroup.control("review").value,
          fraction: rating.value,
          language: languageServices.languageCodeSystem.value,
        ),
      ]);

      await Future.wait([getOrderRideDetail(), getOrderReviewDetail()]);

      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Berhasil mengirimkan penilaian dan ulasan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
