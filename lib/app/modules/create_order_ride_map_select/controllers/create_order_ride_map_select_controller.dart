import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_with_points_model.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:uuid/uuid.dart';

class CreateOrderRideMapSelectController extends GetxController {
  final GeocodingRepository geocodingRepository;
  final DriverNearbyRepository driverNearbyRepository;

  CreateOrderRideMapSelectController({
    required this.geocodingRepository,
    required this.driverNearbyRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 18,
  ).obs;
  final googleMapController = Completer<GoogleMapController>();

  final driverNearbyList = <DriverNearby>[].obs;
  final nearestDistanceDriverNearby = 0.0.obs;
  final markers = <MarkerId, Marker>{}.obs;
  Timer? driverNearbyTimer;

  final type = Rx<String?>(null);

  final address = Rx<String?>(null);
  final addressName = Rx<String?>(null);
  final latitude = Rx<String?>(null);
  final longitude = Rx<String?>(null);

  final isPermissionLocationAllow = false.obs;
  final isFetchAddress = false.obs;
  final isFetch = true.obs;

  final idPinpoint = "".obs;

  final recommendationLocationList = <GeocodingPlaceWithPoints>[].obs;
  final selectedIndexRecommendationLocation = 0.obs;

  final isUserMoveMapCamera = false.obs;
  final isMoveCameraFrom = "user".obs;
  final isRecommendationCameraMove = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    disableDriverNearbyTimer();
  }

  Future<void> getRecommendationLocationList() async {
    recommendationLocationList.value = await geocodingRepository
        .getGeocodingDestinationPointCandidates(
          latitude: double.tryParse(latitude.value!),
          longitude: double.tryParse(longitude.value!),
        );
  }

  // Driver Nearby
  Future<void> getDriverNearByList() async {
    driverNearbyList.value = await driverNearbyRepository.getDriverNearbyList(
      lat: double.tryParse(latitude.value!),
      lon: double.tryParse(longitude.value!),
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
    if (type.value == "origin") {
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
        await refreshPickupLocationMarkers();
      }

      markers.refresh();
    }
  }

  void enableDriverNearbyTimer() {
    driverNearbyTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await refreshMarkerDriverNearby();
    });
  }

  void disableDriverNearbyTimer() {
    driverNearbyTimer?.cancel();
  }

  Future<void> fillForm() async {
    type.value = Get.arguments?['type'];

    address.value = Get.arguments?['address'];
    addressName.value = Get.arguments?['address_name'];
    latitude.value = Get.arguments?['latitude'];
    longitude.value = Get.arguments?['longitude'];

    if (latitude.value != null) {
      var searchedAddress = await geocodingRepository
          .getAddressByLatitudeLongitude(
            latitude: double.parse(latitude.value!),
            longitude: double.parse(longitude.value!),
          );
      address.value = searchedAddress?.address ?? "-";
      addressName.value = searchedAddress?.name ?? "-";
      await moveGoogleMapCameraToFillLocation();
    } else {
      await moveGoogleMapCameraToCurrentLocation();

      var searchedAddress = await geocodingRepository
          .getAddressByLatitudeLongitude(
            latitude: double.parse(latitude.value!),
            longitude: double.parse(longitude.value!),
          );
      address.value = searchedAddress?.address ?? "-";
      addressName.value = searchedAddress?.name ?? "-";
    }

    await getDriverNearByList();
  }

  Future<void> requestLocation() async {
    isPermissionLocationAllow.value = true;
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      isPermissionLocationAllow.value = false;
      return;
    }
  }

  Future<void> moveGoogleMapCameraToCurrentLocation() async {
    await requestLocation();

    if (isPermissionLocationAllow.value == true) {
      var locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      var position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();

      if (isClosed) return;
      (await googleMapController.future).moveCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(latitude.value!), double.parse(longitude.value!)),
        ),
      );
    } else {
      // default
      latitude.value = "-6.1744651";
      longitude.value = "106.822745";

      if (isClosed) return;
      (await googleMapController.future).moveCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(latitude.value!), double.parse(longitude.value!)),
        ),
      );
    }
  }

  Future<void> moveGoogleMapCameraToFillLocation() async {
    if (latitude.value != null && longitude.value != null) {
      if (isClosed) return;
      await (await googleMapController.future).moveCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(latitude.value!), double.parse(longitude.value!)),
        ),
      );
    }
  }

  Future<void> updateLocationLatLng({
    required double? latitude,
    required double? longitude,
  }) async {
    isFetchAddress.value = true;

    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      if (latitude.toString() == this.latitude.value &&
          longitude.toString() == this.longitude.value) {
        print("oke-1");
        this.latitude.value = latitude.toString();
        this.longitude.value = longitude.toString();
        print("oke-2");

        if (isUserMoveMapCamera.value == true) {
          isFetchAddress.value = false;
          return;
        }

        await Future.wait([
          refreshMarkerDriverNearby(),
          setAddressAndAddressName(latitude: latitude!, longitude: longitude!),
          getRecommendationLocationList(),
        ]);
        print("oke-3");

        if (isUserMoveMapCamera.value == true) {
          isFetchAddress.value = false;
          return;
        }

        // get nearest recommendation location based on latitude and longitude
        var nearestRecommendationLocation =
            await getNearestRecommendationLocation();

        if (isUserMoveMapCamera.value == true) {
          isFetchAddress.value = false;
          return;
        }
        print("oke-4");

        var distanceMeter = Geolocator.distanceBetween(
          latitude,
          longitude,
          nearestRecommendationLocation.lat!,
          nearestRecommendationLocation.lng!,
        );

        print("oke-5 ${nearestRecommendationLocation.name} $distanceMeter m");

        if (distanceMeter <= 1) {
          isFetchAddress.value = false;
          return;
        }

        isMoveCameraFrom.value = "system";
        await Future.wait([
          refreshPickupLocationMarkers(),
          (await googleMapController.future).moveCamera(
            CameraUpdate.newLatLng(
              LatLng(
                nearestRecommendationLocation.lat!,
                nearestRecommendationLocation.lng!,
              ),
            ),
          ),
        ]);
        print("oke-6");

        if (isUserMoveMapCamera.value == true) {
          isFetchAddress.value = false;
          return;
        }

        isFetchAddress.value = false;
      }
    });
  }

  Future<GeocodingPlaceWithPoints> getNearestRecommendationLocation() async {
    var nearestRecommendationLocation = recommendationLocationList.first;

    for (var recommendationLocation in recommendationLocationList) {
      var distanceMeter = Geolocator.distanceBetween(
        locationServices.currentLatitude.value!,
        locationServices.currentLongitude.value!,
        recommendationLocation.lat!,
        recommendationLocation.lng!,
      );

      recommendationLocation.customDistanceKm = distanceMeter / 1000;
      recommendationLocation.customDistanceM = distanceMeter;
    }

    for (var recommendationLocation in recommendationLocationList) {
      if (recommendationLocation.distanceMeters! <
          nearestRecommendationLocation.distanceMeters!) {
        nearestRecommendationLocation = recommendationLocation;
      }
    }

    return nearestRecommendationLocation;
  }

  Future<void> setAddressAndAddressName({
    required double latitude,
    required double longitude,
  }) async {
    var searchedAddress = await geocodingRepository
        .getAddressByLatitudeLongitude(
          latitude: latitude,
          longitude: longitude,
        );
    address.value = searchedAddress?.address ?? "-";
    addressName.value = searchedAddress?.name ?? "-";
  }

  void onTapSubmit() {
    Get.back(
      result: {
        "type": type.value,
        "address": address.value,
        "address_name": addressName.value,
        "latitude": latitude.value,
        "longitude": longitude.value,
      },
    );
  }

  Future<void> moveGoogleMapCameraToRecommendationLocation(int index) async {
    if (index < 0 || index >= recommendationLocationList.length) return;
    final location = recommendationLocationList[index];
    if (location.lat == null || location.lng == null) return;
    if (isClosed) return;
    isRecommendationCameraMove.value = true;
    (await googleMapController.future).animateCamera(
      CameraUpdate.newLatLng(LatLng(location.lat!, location.lng!)),
    );
  }

  Future<void> refreshPickupLocationMarkers() async {
    var recommendationPinpointIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(25, 25)),
      'assets/icons/icon_recommendation_pinpoint.png',
    );

    markers.removeWhere(
      (markerId, _) => markerId.value.contains('pickup_location_'),
    );

    for (var index = 0; index < recommendationLocationList.length; index++) {
      final location = recommendationLocationList[index];
      final position = LatLng(location.lat!, location.lng!);

      var uniqueIdMarker = Uuid().v4();

      final markerId = MarkerId('pickup_location_${index}_$uniqueIdMarker');
      markers[markerId] = Marker(
        markerId: markerId,
        position: position,
        icon: recommendationPinpointIcon,
        anchor: Offset(0.5, 0.5),
        zIndexInt: 1,
        onTap: () async {
          // if (selectedPickupLocationIndex.value != index) {
          //   await selectPickupLocation(index);
          // }
        },
      );
    }

    // final selectedLocation = pickupLocationCandidateList[selectedIndex];
    // final selectedPosition = _pickupLocationLatLng(selectedLocation);
    // if (selectedPosition != null) {
    //   const selectedMarkerId = MarkerId('pickup_location_selected');
    //   pickupMarkers[selectedMarkerId] = Marker(
    //     markerId: selectedMarkerId,
    //     position: selectedPosition,
    //     icon: selectedRecommendationPinpointIcon!,
    //     anchor: Offset(0.5, 1.0),
    //     zIndexInt: 2,
    //     onTap: () async {
    //       if (selectedPickupLocationIndex.value != selectedIndex) {
    //         await selectPickupLocation(selectedIndex);
    //       }
    //     },
    //   );
    // }

    markers.refresh();
  }
}
