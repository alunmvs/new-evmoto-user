import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:uuid/uuid.dart';

class CreateOrderRideRecommendationPickupLocationController
    extends GetxController {
  static const backResultFocusDestination = 'focus_destination';

  final DriverNearbyRepository driverNearbyRepository;
  final GeocodingRepository geocodingRepository;

  CreateOrderRideRecommendationPickupLocationController({
    required this.driverNearbyRepository,
    required this.geocodingRepository,
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
  final driverMarkers = <MarkerId, Marker>{}.obs;
  final pickupMarkers = <MarkerId, Marker>{}.obs;
  Timer? driverNearbyTimer;

  final originAddressName = Rx<String?>(null);
  final originAddress = Rx<String?>(null);
  final originLatitude = Rx<String?>(null);
  final originLongitude = Rx<String?>(null);
  final destinationAddressName = Rx<String?>(null);
  final destinationAddress = Rx<String?>(null);
  final destinationLatitude = Rx<String?>(null);
  final destinationLongitude = Rx<String?>(null);

  final pickupLocationCandidateList = <GeocodingPlaceWithPoints>[].obs;
  final selectedPickupLocationIndex = 0.obs;
  final isFetchPickupLocationCandidates = false.obs;

  final isFetch = false.obs;
  final idPinpoint = "".obs;

  BitmapDescriptor? recommendationPinpointIcon;
  BitmapDescriptor? selectedRecommendationPinpointIcon;

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
        originLatitude.value = locationServices.currentLatitude.value
            .toString();
        originLongitude.value = locationServices.currentLongitude.value
            .toString();
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

    await getPickupLocationCandidateList();
    if (pickupLocationCandidateList.isEmpty) {
      await moveCameraToLocation();
      await refreshMarkerDriverNearby();
    }
    enableDriverNearbyTimer();
    isFetch.value = false;
  }

  Future<void> getPickupLocationCandidateList() async {
    isFetchPickupLocationCandidates.value = true;

    try {
      pickupLocationCandidateList.value = await geocodingRepository
          .getGeocodingDestinationPointCandidates(
            latitude: double.tryParse(originLatitude.value ?? ''),
            longitude: double.tryParse(originLongitude.value ?? ''),
          );

      if (pickupLocationCandidateList.isNotEmpty) {
        await selectPickupLocation(0);
        await moveCameraToFitPickupLocationCandidates();
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    } finally {
      isFetchPickupLocationCandidates.value = false;
    }
  }

  Future<void> selectPickupLocation(int index) async {
    if (index < 0 || index >= pickupLocationCandidateList.length) {
      return;
    }

    selectedPickupLocationIndex.value = index;
    final selectedLocation = pickupLocationCandidateList[index];
    final selectedPosition = _pickupLocationLatLng(selectedLocation);

    originLatitude.value = selectedPosition?.latitude.toString();
    originLongitude.value = selectedPosition?.longitude.toString();
    originAddressName.value =
        selectedLocation.name ?? selectedLocation.pointRecommendation?.name;
    originAddress.value =
        selectedLocation.address ??
        selectedLocation.pointRecommendation?.address;

    await refreshPickupLocationMarkers();
    await refreshMarkerDriverNearby();
  }

  LatLng? _pickupLocationLatLng(GeocodingPlaceWithPoints location) {
    if (location.lat != null && location.lng != null) {
      return LatLng(location.lat!, location.lng!);
    }

    final fallback = location.pointRecommendation?.fallbackPoint;
    if (fallback != null) {
      final lat = fallback.osrmLat ?? fallback.rawLat;
      final lng = fallback.osrmLng ?? fallback.rawLng;
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }

    return null;
  }

  List<LatLng> _pickupLocationCandidatePoints() {
    return pickupLocationCandidateList
        .map(_pickupLocationLatLng)
        .whereType<LatLng>()
        .toList();
  }

  Future<void> moveCameraToFitPickupLocationCandidates() async {
    final points = _pickupLocationCandidatePoints();
    if (points.isEmpty || isClosed) {
      return;
    }

    final mapController = await googleMapController.future;
    final bounds = latLngBoundsFromPoints(points, minSpanMeters: 300);
    final latSpan = bounds.northeast.latitude - bounds.southwest.latitude;
    final lngSpan = bounds.northeast.longitude - bounds.southwest.longitude;
    final latPadding = latSpan * 0.2;
    final lngPadding = lngSpan * 0.2;

    // Perluas bounds sedikit + geser ke selatan agar pinpoint tidak tertutup footer.
    final shiftedBounds = LatLngBounds(
      southwest: LatLng(
        bounds.southwest.latitude - latPadding - (latSpan * 0.55),
        bounds.southwest.longitude - lngPadding,
      ),
      northeast: LatLng(
        bounds.northeast.latitude + latPadding,
        bounds.northeast.longitude + lngPadding,
      ),
    );

    try {
      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(shiftedBounds, 100),
      );
    } catch (_) {
      await animateMapToFitPoints(
        mapController,
        points,
        edgePadding: 100,
        minSpanMeters: 300,
      );
    }
  }

  Future<void> _ensurePickupLocationMarkerIconsLoaded() async {
    recommendationPinpointIcon ??= await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(25, 25)),
      'assets/icons/icon_recommendation_pinpoint.png',
    );
    selectedRecommendationPinpointIcon ??= await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(39, 58)),
      'assets/icons/icon_selected_recommendation_pinpoint.png',
    );
  }

  Future<void> refreshPickupLocationMarkers() async {
    await _ensurePickupLocationMarkerIconsLoaded();

    pickupMarkers.clear();

    final selectedIndex = selectedPickupLocationIndex.value;

    for (var index = 0; index < pickupLocationCandidateList.length; index++) {
      final location = pickupLocationCandidateList[index];
      final position = _pickupLocationLatLng(location);
      if (position == null) {
        continue;
      }

      final markerId = MarkerId('pickup_location_$index');
      pickupMarkers[markerId] = Marker(
        markerId: markerId,
        position: position,
        icon: recommendationPinpointIcon!,
        anchor: Offset(0.5, 0.5),
        zIndexInt: 1,
        onTap: () async {
          if (selectedPickupLocationIndex.value != index) {
            await selectPickupLocation(index);
          }
        },
      );
    }

    final selectedLocation = pickupLocationCandidateList[selectedIndex];
    final selectedPosition = _pickupLocationLatLng(selectedLocation);
    if (selectedPosition != null) {
      const selectedMarkerId = MarkerId('pickup_location_selected');
      pickupMarkers[selectedMarkerId] = Marker(
        markerId: selectedMarkerId,
        position: selectedPosition,
        icon: selectedRecommendationPinpointIcon!,
        anchor: Offset(0.5, 1.0),
        zIndexInt: 2,
        onTap: () async {
          if (selectedPickupLocationIndex.value != selectedIndex) {
            await selectPickupLocation(selectedIndex);
          }
        },
      );
    }

    pickupMarkers.refresh();
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

  Future<void> moveGoogleMapCameraToCurrentLocation() async {
    if (pickupLocationCandidateList.isNotEmpty) {
      await moveCameraToFitPickupLocationCandidates();
      return;
    }

    await moveCameraToLocation();
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
      driverMarkers[markerId] = markerDriverNearby;
    }

    var removedMarkerIdList = <MarkerId>[];
    for (var markerId in driverMarkers.keys) {
      if (!markerId.value.startsWith('driver_nearby_')) {
        continue;
      }

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

    for (var markerId in removedMarkerIdList) {
      driverMarkers.remove(markerId);
    }

    driverMarkers.refresh();
  }

  void enableDriverNearbyTimer() {
    driverNearbyTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await refreshMarkerDriverNearby();
    });
  }

  void disableDriverNearbyTimer() {
    driverNearbyTimer?.cancel();
  }

  void onTapBackToCreateOrderRide() {
    disableDriverNearbyTimer();
    Get.back(result: backResultFocusDestination);
  }

  void onTapSelectPickupLocation() {
    if (originLatitude.value == null ||
        originLongitude.value == null ||
        destinationLatitude.value == null ||
        destinationLongitude.value == null) {
      SnackbarHelper.showSnackbarError(
        text:
            languageServices.language.value.snackbarRequiredNotSuccess ?? '-',
      );
      return;
    }

    disableDriverNearbyTimer();

    Get.toNamed(
      Routes.CREATE_ORDER_RIDE_CHECKOUT,
      arguments: {
        'origin_address_name': originAddressName.value,
        'origin_address': originAddress.value,
        'origin_latitude': originLatitude.value,
        'origin_longitude': originLongitude.value,
        'destination_address_name': destinationAddressName.value,
        'destination_address': destinationAddress.value,
        'destination_latitude': destinationLatitude.value,
        'destination_longitude': destinationLongitude.value,
      },
    );
  }
}
