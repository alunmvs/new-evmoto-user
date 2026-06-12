import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:uuid/uuid.dart';

class AdvancedBookingSearchingDriverController extends GetxController {
  final AdvanceBookingRepository advanceBookingRepository;
  final DriverNearbyRepository driverNearbyRepository;

  AdvancedBookingSearchingDriverController({
    required this.advanceBookingRepository,
    required this.driverNearbyRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  final googleMapController = Completer<GoogleMapController>();
  // final isGoogleMapControllerCreated = false.obs;

  final markers = <MarkerId, Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final isPinLocationWaitingForDriverHide = false.obs;

  final driverNearbyList = <DriverNearby>[].obs;
  final nearestDistanceDriverNearby = 0.0.obs;
  Timer? driverNearbyTimer;

  final advanceBookingId = Rx<int?>(null);
  final advancedBooking = AdvancedBooking().obs;

  final idPinpoint = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    advanceBookingId.value = Get.arguments['id'];

    await Future.wait([getAdvancedBookingDetail()]);
    await Future.wait([
      refreshMarkerDriverNearby(),
      setupMapWaitingForDriver(),
    ]);

    enableDriverNearbyTimer();

    isFetch.value = false;

    await Future.delayed(Duration(seconds: 5)).whenComplete(() async {
      Get.back();
      Get.toNamed(
        Routes.ADVANCED_BOOKING_DETAIL,
        arguments: {"id": advanceBookingId.value},
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    try {
      (await googleMapController.future).dispose();
    } catch (e) {}

    try {
      disableDriverNearbyTimer();
    } catch (e) {}
  }

  Future<void> setupMapWaitingForDriver() async {
    if (isClosed) return;
    await (await googleMapController.future).animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          advancedBooking.value.startLat!,
          advancedBooking.value.startLon!,
        ),
        16,
      ),
    );
    isPinLocationWaitingForDriverHide.value = false;
  }

  Future<void> getAdvancedBookingDetail() async {
    advancedBooking.value =
        (await advanceBookingRepository.getAdvancedBookingDetail(
          id: advanceBookingId.value,
        )) ??
        AdvancedBooking();
  }

  Future<void> getDriverNearByList() async {
    driverNearbyList.value = await driverNearbyRepository.getDriverNearbyList(
      lat: advancedBooking.value.startLat,
      lon: advancedBooking.value.startLon,
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

    if (idPinpoint.value == "") {
      idPinpoint.value = Uuid().v4();
    }

    for (var driverNearby in driverNearbyList) {
      var markerId = MarkerId(
        "driver_nearby_${driverNearby.driverId}_${idPinpoint.value}",
      );
      // var widgetBitmapDescriptor =
      //     await DriverNearbyPositionWidget(
      //       driverNearby: driverNearby,
      //     ).toMarkerBitmap(
      //       navigatorKey.currentContext!,
      //       logicalSize: Size(64, 106),
      //     );
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

    var removedMarkerIdList = <MarkerId>[];
    for (var markerId in markers.keys) {
      var isExist = false;
      for (var driverNearby in driverNearbyList) {
        if (markerId.value ==
            "driver_nearby_${driverNearby.driverId}_${idPinpoint.value}") {
          isExist = true;
        }
      }

      if ([
        "driver",
        "origin",
        "destination",
        "driver_current_location",
        "appointment_origin",
      ].contains(markerId.value)) {
        isExist = true;
      }

      if (isExist == false) {
        // var widgetBitmapDescriptor =
        //     await DriverNearbyPositionWidget(
        //       driverNearby: DriverNearby(),
        //     ).toMarkerBitmap(
        //       navigatorKey.currentContext!,
        //       logicalSize: Size(64, 106),
        //     );
        // var markerDriverNearby = Marker(
        //   markerId: markerId,
        //   position: LatLng(0.0, 0.0),
        //   // icon: widgetBitmapDescriptor,
        //   icon: await BitmapDescriptor.asset(
        //     ImageConfiguration(size: Size(64, 106)),
        //     'assets/icons/icon_driver.png',
        //   ),
        //   anchor: Offset(0.5, 0.5),
        //   visible: false,
        // );
        // markers[markerId] = markerDriverNearby;
        removedMarkerIdList.add(markerId);
      }
    }

    if (removedMarkerIdList.isNotEmpty) {
      idPinpoint.value = "";
      markers.clear();
      await refreshMarkerDriverNearby();
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
}
