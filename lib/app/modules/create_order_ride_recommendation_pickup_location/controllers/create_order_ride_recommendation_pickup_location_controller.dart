import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:uuid/uuid.dart';

class CreateOrderRideRecommendationPickupLocationController
    extends GetxController {
  final DriverNearbyRepository driverNearbyRepository;

  CreateOrderRideRecommendationPickupLocationController({
    required this.driverNearbyRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  final googleMapController = Completer<GoogleMapController>();

  final driverNearbyList = <DriverNearby>[].obs;
  final nearestDistanceDriverNearby = 0.0.obs;
  final markers = <MarkerId, Marker>{}.obs;
  Timer? driverNearbyTimer;

  final originAddressName = Rx<String?>(null);
  final originAddress = Rx<String?>(null);
  final originLatitude = Rx<String?>(null);
  final originLongitude = Rx<String?>(null);
  final destinationAddressName = Rx<String?>(null);
  final destinationAddress = Rx<String?>(null);
  final destinationLatitude = Rx<String?>(null);
  final destinationLongitude = Rx<String?>(null);

  final isFetch = false.obs;
  final idPinpoint = "".obs;

  @override
  void onInit() {
    super.onInit();
    fillForm();
  }

  @override
  void onClose() {
    disableDriverNearbyTimer();
    super.onClose();
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

    if (originLatitude.value != null && originLongitude.value != null) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(
          double.parse(originLatitude.value!),
          double.parse(originLongitude.value!),
        ),
        zoom: 14,
      );
    }
  }

  Future<void> onMapCreated() async {
    isFetch.value = true;

    if (originLatitude.value == null || originLongitude.value == null) {
      await locationServices.requestLocation();
      if (locationServices.currentLatitude.value != null) {
        originLatitude.value =
            locationServices.currentLatitude.value.toString();
        originLongitude.value =
            locationServices.currentLongitude.value.toString();
        initialCameraPosition.value = CameraPosition(
          target: LatLng(
            locationServices.currentLatitude.value!,
            locationServices.currentLongitude.value!,
          ),
          zoom: 14,
        );
      } else {
        originLatitude.value = "-6.1744651";
        originLongitude.value = "106.822745";
      }
    }

    await moveCameraToLocation();
    await refreshMarkerDriverNearby();
    enableDriverNearbyTimer();
    isFetch.value = false;
  }

  Future<void> moveCameraToLocation() async {
    if (originLatitude.value != null &&
        originLongitude.value != null &&
        !isClosed) {
      await (await googleMapController.future).moveCamera(
        CameraUpdate.newLatLng(
          LatLng(
            double.parse(originLatitude.value!),
            double.parse(originLongitude.value!),
          ),
        ),
      );
    }
  }

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

    if (idPinpoint.value == "") {
      idPinpoint.value = Uuid().v4();
    }

    for (var driverNearby in driverNearbyList) {
      var markerId = MarkerId(
        "driver_nearby_${driverNearby.driverId}_${idPinpoint.value}",
      );
      var markerDriverNearby = Marker(
        markerId: markerId,
        position: LatLng(driverNearby.lat!, driverNearby.lon!),
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

      if (isExist == false) {
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
