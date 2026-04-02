import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';
import 'package:new_evmoto_user/main.dart';

class CreateOrderRideCheckoutController extends GetxController {
  final OrderRideRepository orderRideRepository;
  final GeocodingRepository geocodingRepository;
  final OpenMapsRepository openMapsRepository;
  final CouponRepository couponRepository;

  CreateOrderRideCheckoutController({
    required this.orderRideRepository,
    required this.geocodingRepository,
    required this.openMapsRepository,
    required this.couponRepository,
  });

  final homeController = Get.find<HomeController>();
  final createOrderRideController = Get.find<CreateOrderRideController>();
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final orderRidePricingList = <OrderRidePricing>[].obs;
  final selectedOrderRidePricing = OrderRidePricing().obs;
  final availableCouponList = <Coupon>[].obs;

  final payType = 3.obs;
  final selectedCoupon = Coupon().obs;

  final originAddressName = Rx<String?>(null);
  final originAddress = Rx<String?>(null);
  final originLatitude = Rx<String?>(null);
  final originLongitude = Rx<String?>(null);
  final destinationAddressName = Rx<String?>(null);
  final destinationAddress = Rx<String?>(null);
  final destinationLatitude = Rx<String?>(null);
  final destinationLongitude = Rx<String?>(null);

  final estimatedTimeInMinutes = 0.0.obs;
  final estimatedDistanceInKm = 0.0.obs;
  final estimatedSpeedInKmh = 40.obs;

  final isPermissionLocationAllow = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fillForm();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getAvailableCouponList() async {
    availableCouponList.value = await couponRepository.getCouponList(
      state: 1,
      language: languageServices.languageCodeSystem.value,
      pageNum: 1,
      size: 1,
    );

    if (availableCouponList.isNotEmpty) {
      selectedCoupon.value = availableCouponList.first;
    }
  }

  void fillForm() {
    originAddressName.value = Get.arguments['origin_address_name'];
    originAddress.value = Get.arguments['origin_address'];
    originLatitude.value = Get.arguments['origin_latitude'];
    originLongitude.value = Get.arguments['origin_longitude'];
    destinationAddressName.value = Get.arguments['destination_address_name'];
    destinationAddress.value = Get.arguments['destination_address'];
    destinationLatitude.value = Get.arguments['destination_latitude'];
    destinationLongitude.value = Get.arguments['destination_longitude'];
  }

  Future<void> generatePolylinesOpenMapsApi() async {
    var openMapDirection = await openMapsRepository.getDirection(
      originLatitude: originLatitude.value,
      originLongitude: originLongitude.value,
      destinationLatitude: destinationLatitude.value,
      destinationLongitude: destinationLongitude.value,
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
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF4DABF5),
        width: 6,
      ),
    );
  }

  Future<void> refocusMapsBound() async {
    LatLngBounds bounds;

    var originLatitude = double.parse(this.originLatitude.value!);
    var originLongitude = double.parse(this.originLongitude.value!);
    var destinationLatitude = double.parse(this.destinationLatitude.value!);
    var destinationLongitude = double.parse(this.destinationLongitude.value!);

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

    var movementDirection = compareLatLng(
      originLat: originLatitude,
      originLng: originLongitude,
      destLat: destinationLatitude,
      destLng: destinationLongitude,
    );

    if (movementDirection == MovementDirection.vertical) {
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, Get.height * 0.1),
      );
    } else {
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
      );
    }
  }

  MovementDirection compareLatLng({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    final double deltaLat = (destLat - originLat).abs();
    final double deltaLng = (destLng - originLng).abs();

    if (deltaLat > deltaLng) {
      return MovementDirection.vertical;
    } else {
      return MovementDirection.horizontal;
    }
  }

  Future<void> getOrderRidePricingList() async {
    orderRidePricingList.value = (await orderRideRepository
        .getOrderRidePricingList(
          startLonLat: "${originLongitude.value},${originLatitude.value}",
          endLonLat:
              "${destinationLongitude.value},${destinationLatitude.value}",
          language: languageServices.languageCodeSystem.value,
          type: 1,
          couponId: selectedCoupon.value.id,
        ));

    selectedOrderRidePricing.value = orderRidePricingList.first;
  }

  Future<void> setLatitudeLongitudeMarker() async {
    markers.add(
      Marker(
        markerId: MarkerId("origin"),
        position: LatLng(
          double.parse(originLatitude.value!),
          double.parse(originLongitude.value!),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint_map_green.svg',
          Size(28, 35),
        ),
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: LatLng(
          double.parse(destinationLatitude.value!),
          double.parse(destinationLongitude.value!),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint_map_red.svg',
          Size(28, 35),
        ),
      ),
    );
  }

  void generateEstimatedDistanceAndTimeInMinutes() {
    estimatedDistanceInKm.value = calculateTotalDistance(polylinesCoordinate);
    estimatedTimeInMinutes.value =
        (estimatedDistanceInKm.value / estimatedSpeedInKmh.value) * 60;
  }

  String getEstimatedTimeInMinutesInText() {
    if (selectedOrderRidePricing.value.duration == null) {
      return '';
    }
    int hours = selectedOrderRidePricing.value.duration! ~/ 60;
    int mins = (selectedOrderRidePricing.value.duration! % 60).round();

    if (hours > 0) {
      if (mins > 0) {
        return '$hours ${languageServices.language.value.hour} $mins ${languageServices.language.value.minute}';
      } else {
        return '$hours ${languageServices.language.value.hour}';
      }
    } else {
      return '$mins ${languageServices.language.value.minute}';
    }
  }

  Future<void> onTapSubmit() async {
    await locationServices.requestLocation();
    if (locationServices.isPermissionLocationAllow.value == true) {
      Get.dialog(LoadingDialog(), barrierDismissible: false);
      try {
        var result = await orderRideRepository.requestOrderRide(
          language: languageServices.languageCodeSystem.value,
          endAddress: destinationAddress.value,
          endLat: destinationLatitude.value,
          endLon: destinationLongitude.value,
          startAddress: originAddress.value,
          startLat: originLatitude.value,
          startLon: originLongitude.value,
          orderSource: "1", // statis 1
          orderType: 1, // 1 = normal, 2 = appointment
          passengers: homeController.userServices.userInfo.value.name,
          passengersPhone: homeController.userServices.userInfo.value.phone,
          placementLat: locationServices.currentLatitude.value.toString(),
          placementLon: locationServices.currentLongitude.value.toString(),
          tipMoney: "0",
          serverCarModelId: selectedOrderRidePricing.value.id.toString(),
          substitute: "0", // 0 = no, 1 = yes
          travelTime: DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime.now(),
          ), // kalau orderType = 1, kalau 2 maka sesuai tanggal dan jamnya
          type: "1", // 1 = Ride, 2 = Intercity
          amount: selectedOrderRidePricing.value.amount,
          payType: payType.value,
          couponId: selectedCoupon.value.id,
          priceNo: selectedOrderRidePricing.value.priceNo,
          startAddressName: originAddressName.value,
          endAddressName: destinationAddressName.value,
        );
        Get.close(1);

        Get.back();
        Get.back();
        Get.toNamed(
          Routes.RIDE_ORDER_DETAIL,
          arguments: {"order_id": result.id.toString(), "order_type": 1},
        );
      } on DioException catch (e) {
        Get.close(1);
        SnackbarHelper.showSnackbarError(text: e.error.toString());
      } on Exception catch (e) {
        Get.close(1);
        SnackbarHelper.showSnackbarError(text: e.toString());
      }
    }
  }
}

enum MovementDirection { vertical, horizontal }
