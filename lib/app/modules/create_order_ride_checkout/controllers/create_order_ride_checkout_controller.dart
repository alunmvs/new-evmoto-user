import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:marker_widget/marker_widget.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/driver_nearby_position_widget.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';
import 'package:new_evmoto_user/main.dart';

class CreateOrderRideCheckoutController extends GetxController {
  final OrderRideRepository orderRideRepository;
  final GeocodingRepository geocodingRepository;
  final OpenMapsRepository openMapsRepository;
  final CouponRepository couponRepository;
  final DriverNearbyRepository driverNearbyRepository;
  final AdvanceBookingRepository advanceBookingRepository;

  CreateOrderRideCheckoutController({
    required this.orderRideRepository,
    required this.geocodingRepository,
    required this.openMapsRepository,
    required this.couponRepository,
    required this.driverNearbyRepository,
    required this.advanceBookingRepository,
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
  final googleMapController = Completer<GoogleMapController>();

  // final markers = <Marker>{}.obs;
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

  final driverNearbyList = <DriverNearby>[].obs;
  final nearestDistanceDriverNearby = 0.0.obs;
  final markers = <MarkerId, Marker>{}.obs;
  Timer? driverNearbyTimer;

  // Advanced Order
  final minDateTimeAdvanceOrder = Rx<DateTime?>(null);
  final maxDateTimeAdvanceOrder = Rx<DateTime?>(null);
  final dateRecommendationList = <DateTime>[].obs;
  final timeRecommendationList = <DateTime>[].obs;

  final selectedDate = Rx<DateTime?>(null);
  final selectedTime = Rx<DateTime?>(null);

  final selectedDateIndex = 0.obs;
  final selectedTimeIndex = 0.obs;

  final isAdvanceOrderEnable = false.obs;

  final isPermissionLocationAllow = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fillForm();
    await generateMinMaxDateTimeAdvanceOrder();
    await generateDateRecommendationList();
    timeRecommendationList.value = await generateTimeRecommendationList(
      selectedDate: selectedDate.value!,
    );
    selectedTime.value = timeRecommendationList.first;
    selectedTimeIndex.value = 0;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> generateMinMaxDateTimeAdvanceOrder() async {
    minDateTimeAdvanceOrder.value = DateTime.now().add(Duration(minutes: 30));
    maxDateTimeAdvanceOrder.value = DateTime.now().add(Duration(hours: 18));
  }

  Future<void> generateDateRecommendationList() async {
    var maxDay =
        minDateTimeAdvanceOrder.value!.day == maxDateTimeAdvanceOrder.value!.day
        ? 1
        : 2;

    for (var i = 0; i < maxDay; i++) {
      dateRecommendationList.add(
        DateTime(
          minDateTimeAdvanceOrder.value!.year,
          minDateTimeAdvanceOrder.value!.month,
          minDateTimeAdvanceOrder.value!.day + i,
        ),
      );
    }

    selectedDate.value = dateRecommendationList.first;
  }

  Future<List<DateTime>> generateTimeRecommendationList({
    required DateTime selectedDate,
  }) async {
    final now = DateTime.now();

    final minDateTime = minDateTimeAdvanceOrder.value!;
    final maxDateTime = maxDateTimeAdvanceOrder.value!;

    final isToday =
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    DateTime start;

    if (isToday) {
      start = minDateTime;
    } else {
      start = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        0,
        0,
      );
    }

    DateTime endOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      23,
      59,
    );

    final end = isToday
        ? (endOfDay.isAfter(maxDateTime) ? maxDateTime : endOfDay)
        : endOfDay;

    int remainder = start.minute % 5;
    if (remainder != 0) {
      start = start.add(Duration(minutes: 5 - remainder));
    }

    start = DateTime(
      start.year,
      start.month,
      start.day,
      start.hour,
      start.minute,
    );

    final List<DateTime> result = [];

    while (!start.isAfter(end)) {
      result.add(start);
      start = start.add(const Duration(minutes: 5));
    }

    return result;
  }

  // Driver Nearby
  Future<void> getDriverNearByList() async {
    driverNearbyList.value = await driverNearbyRepository.getDriverNearbyList(
      lat: double.tryParse(originLatitude.value!),
      lon: double.tryParse(originLongitude.value!),
    );

    if (driverNearbyList.isEmpty) {
      nearestDistanceDriverNearby.value = 0.0;
    } else {
      var nearestDistanceDriverNearby = 0.0;

      for (var driverNearby in driverNearbyList) {
        if (nearestDistanceDriverNearby == 0.0) {
          nearestDistanceDriverNearby = driverNearby.distance ?? 0.0;
        } else {
          if ((driverNearby.distance ?? 0.0) < nearestDistanceDriverNearby) {
            nearestDistanceDriverNearby = driverNearby.distance ?? 0.0;
          }
        }
      }

      this.nearestDistanceDriverNearby.value = nearestDistanceDriverNearby;
    }
  }

  Future<void> refreshMarkerDriverNearby() async {
    await getDriverNearByList();

    for (var driverNearby in driverNearbyList) {
      var markerId = MarkerId("driver_nearby_${driverNearby.driverId}");
      var widgetBitmapDescriptor =
          await DriverNearbyPositionWidget(
            driverNearby: driverNearby,
          ).toMarkerBitmap(
            navigatorKey.currentContext!,
            logicalSize: Size(64, 106),
          );
      var markerDriverNearby = Marker(
        markerId: markerId,
        position: LatLng(driverNearby.lat!, driverNearby.lon!),
        // icon: widgetBitmapDescriptor,
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: true,
      );
      markers[markerId] = markerDriverNearby;
    }

    for (var markerId in markers.keys) {
      var isExist = false;
      for (var driverNearby in driverNearbyList) {
        if (markerId.value == "driver_nearby_${driverNearby.driverId}") {
          isExist = true;
        }
      }

      if (markerId.value == "origin" || markerId.value == "destination") {
        isExist = true;
      }

      if (isExist == false) {
        var widgetBitmapDescriptor =
            await DriverNearbyPositionWidget(
              driverNearby: DriverNearby(),
            ).toMarkerBitmap(
              navigatorKey.currentContext!,
              logicalSize: Size(64, 106),
            );
        var markerDriverNearby = Marker(
          markerId: markerId,
          position: LatLng(0.0, 0.0),
          // icon: widgetBitmapDescriptor,
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(64, 106)),
            'assets/icons/icon_driver.png',
          ),
          anchor: Offset(0.5, 0.5),
          visible: false,
        );
        markers[markerId] = markerDriverNearby;
      }
    }

    markers.refresh();
  }

  void enableDriverNearbyTimer() {
    driverNearbyTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await refreshMarkerDriverNearby();
    });
  }

  void disableDriverNearbyTimer() {
    driverNearbyTimer?.cancel();
  }

  Future<void> getAvailableCouponList() async {
    availableCouponList.value = await couponRepository.getCouponList(
      state: 1,
      language: languageServices.languageCodeSystem.value,
      pageNum: 1,
      size: 1,
      priceNo: selectedOrderRidePricing.value.priceNo,
      amount: selectedOrderRidePricing.value.amount,
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

    if (isClosed) return;
    if (movementDirection == MovementDirection.vertical) {
      await (await googleMapController.future).animateCamera(
        CameraUpdate.newLatLngBounds(bounds, Get.height * 0.2),
      );
    } else {
      await (await googleMapController.future).animateCamera(
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
    markers[MarkerId("origin")] = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(
        double.parse(originLatitude.value!),
        double.parse(originLongitude.value!),
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size((33), (39))),
        'assets/icons/icon_pinpoint_map_green.png',
      ),
      anchor: Offset(0.5, 0.5),
    );

    markers[MarkerId("destination")] = Marker(
      markerId: MarkerId("destination"),
      position: LatLng(
        double.parse(destinationLatitude.value!),
        double.parse(destinationLongitude.value!),
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_red.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
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
    Get.dialog(LoadingDialog(), barrierDismissible: false);
    await locationServices.requestLocation();
    if (locationServices.isPermissionLocationAllow.value == true) {
      if (isAdvanceOrderEnable.value == false) {
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
        } catch (e) {
          Get.close(1);

          await Future.delayed(Duration(milliseconds: 100));

          if (e.toString() == "The price scheme is not exist" ||
              e.toString() == "Skema harga tidak ada" ||
              e.toString() == "价格方案不存在") {
            await getOrderRidePricingList();
            await getAvailableCouponList();
            await Future.wait([getOrderRidePricingList()]);

            await Get.bottomSheet(
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Material(
                      color: themeColorServices.neutralsColorGrey0.value,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        themeColorServices.primaryBlue.value,
                                    radius: 52 / 2,
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_wallet_1.svg",
                                      width: 26,
                                      height: 26,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.close(1);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .tripPriceUpdatedTitle ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value,
                            ),
                            SizedBox(height: 4),
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .tripPriceUpdatedDescription ??
                                  "-",
                              style: typographyServices.bodySmallRegular.value,
                            ),
                            SizedBox(height: 16),
                            LoaderElevatedButton(
                              child: Text(
                                languageServices
                                        .language
                                        .value
                                        .tripPriceUpdatedButton ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                              onPressed: () async {
                                Get.close(1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }

      if (isAdvanceOrderEnable.value == true) {
        try {
          var advanceBookingId = await advanceBookingRepository
              .requestAdvanceBooking(
                endAddress: destinationAddress.value,
                endLat: destinationLatitude.value,
                endLon: destinationLongitude.value,
                startAddress: originAddress.value,
                startLat: originLatitude.value,
                startLon: originLongitude.value,
                passengers: homeController.userServices.userInfo.value.name,
                placementLat: locationServices.currentLatitude.value.toString(),
                placementLon: locationServices.currentLongitude.value
                    .toString(),
                tipMoney: "0",
                serverCarModelId: selectedOrderRidePricing.value.id.toString(),
                substitute: "0", // 0 = no, 1 = yes
                travelTime:
                    "${DateFormat('yyyy-MM-dd').format(selectedDate.value!)} ${DateFormat('HH:mm').format(selectedTime.value!)}:00", // kalau orderType = 1, kalau 2 maka sesuai tanggal dan jamnya
                orderMoney: selectedOrderRidePricing.value.amount!.round(),
                payManner: 2,
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
            Routes.ADVANCED_BOOKING_DETAIL,
            arguments: {"id": advanceBookingId},
          );
        } on DioException catch (e) {
          Get.close(1);
          SnackbarHelper.showSnackbarError(text: e.error.toString());
        } on Exception catch (e) {
          Get.close(1);
          SnackbarHelper.showSnackbarError(text: e.toString());
        } catch (e) {
          Get.close(1);

          await Future.delayed(Duration(milliseconds: 100));

          if (e.toString() == "The price scheme is not exist" ||
              e.toString() == "Skema harga tidak ada" ||
              e.toString() == "价格方案不存在") {
            await getOrderRidePricingList();
            await getAvailableCouponList();
            await Future.wait([getOrderRidePricingList()]);

            await Get.bottomSheet(
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Material(
                      color: themeColorServices.neutralsColorGrey0.value,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        themeColorServices.primaryBlue.value,
                                    radius: 52 / 2,
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_wallet_1.svg",
                                      width: 26,
                                      height: 26,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.close(1);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .tripPriceUpdatedTitle ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value,
                            ),
                            SizedBox(height: 4),
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .tripPriceUpdatedDescription ??
                                  "-",
                              style: typographyServices.bodySmallRegular.value,
                            ),
                            SizedBox(height: 16),
                            LoaderElevatedButton(
                              child: Text(
                                languageServices
                                        .language
                                        .value
                                        .tripPriceUpdatedButton ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                              onPressed: () async {
                                Get.close(1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
    } else {
      Get.close(1);
    }
  }

  String getAdvanceBookingSelectedDateTime() {
    var selectedDateString = "";
    var selectedTimeString = "";
    if (selectedDate.value != null) {
      selectedDateString = DateFormat(
        'EEEE, dd/MM/yyyy',
        'id_ID',
      ).format(selectedDate.value!);
    }

    if (selectedTime.value != null) {
      selectedTimeString = DateFormat('HH:mm').format(selectedTime.value!);
    }

    if (selectedDate.value == null || selectedTime.value == null) {
      return "-";
    } else {
      return "$selectedDateString - $selectedTimeString";
    }
  }
}

enum MovementDirection { vertical, horizontal }
