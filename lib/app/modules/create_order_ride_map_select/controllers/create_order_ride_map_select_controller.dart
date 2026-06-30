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
  bool _isDriverNearbyRefreshInProgress = false;
  BitmapDescriptor? _driverNearbyIcon;
  BitmapDescriptor? _recommendationPinpointIcon;

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

  Timer? _locationUpdateDebounceTimer;
  int _locationUpdateGeneration = 0;

  final noteTextEditingController = TextEditingController();
  final pickupNote = Rx<String?>(null);
  final title = Rx<String?>(null);

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
    _locationUpdateDebounceTimer?.cancel();
    disableDriverNearbyTimer();
  }

  void onUserCameraMoveStarted() {
    _locationUpdateDebounceTimer?.cancel();
    _locationUpdateGeneration++;
    isUserMoveMapCamera.value = true;
    isMoveCameraFrom.value = "user";
    removePickupLocationMarkers();
  }

  void removePickupLocationMarkers() {
    final hasPickupMarkers = markers.keys.any(
      (markerId) => markerId.value.contains('pickup_location_'),
    );
    if (!hasPickupMarkers) return;

    markers.removeWhere(
      (markerId, _) => markerId.value.contains('pickup_location_'),
    );
    markers.refresh();
  }

  void onProgrammaticCameraIdle() {
    isRecommendationCameraMove.value = false;
    isUserMoveMapCamera.value = false;
    isMoveCameraFrom.value = "system";
  }

  bool _isLocationUpdateStale(int generation) =>
      generation != _locationUpdateGeneration;

  Future<void> _moveCameraProgrammatically(LatLng target) async {
    if (isClosed) return;
    isRecommendationCameraMove.value = true;
    isMoveCameraFrom.value = "system";
    await (await googleMapController.future).moveCamera(
      CameraUpdate.newLatLng(target),
    );
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
    final lat = double.tryParse(latitude.value ?? '');
    final lon = double.tryParse(longitude.value ?? '');
    if (lat == null || lon == null) {
      driverNearbyList.clear();
      nearestDistanceDriverNearby.value = 0.0;
      return;
    }

    driverNearbyList.value = await driverNearbyRepository.getDriverNearbyList(
      lat: lat,
      lon: lon,
    );

    if (driverNearbyList.isEmpty) {
      nearestDistanceDriverNearby.value = 0.0;
      return;
    }

    _updateNearestDistanceDriverNearbyFromCoordinates(lat: lat, lon: lon);
  }

  void _updateNearestDistanceDriverNearbyFromCoordinates({
    required double lat,
    required double lon,
  }) {
    if (driverNearbyList.isEmpty) {
      nearestDistanceDriverNearby.value = 0.0;
      return;
    }

    var nearest = double.infinity;
    for (final driverNearby in driverNearbyList) {
      if (driverNearby.lat == null || driverNearby.lon == null) continue;

      final distanceMeter = Geolocator.distanceBetween(
        lat,
        lon,
        driverNearby.lat!,
        driverNearby.lon!,
      );

      if (distanceMeter < nearest) {
        nearest = distanceMeter;
      }
    }

    nearestDistanceDriverNearby.value = nearest == double.infinity
        ? 0.0
        : nearest;
  }

  Future<BitmapDescriptor> _getDriverNearbyIcon() async {
    return _driverNearbyIcon ??= await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(64, 106)),
      'assets/icons/icon_driver.png',
    );
  }

  void _syncDriverNearbyMarkers(BitmapDescriptor icon) {
    if (idPinpoint.value.isEmpty) {
      idPinpoint.value = const Uuid().v4();
    }

    final activeMarkerIds = <String>{};
    for (final driverNearby in driverNearbyList) {
      if (driverNearby.lat == null || driverNearby.lon == null) continue;

      final markerIdValue =
          'driver_nearby_${driverNearby.driverId}_${idPinpoint.value}';
      activeMarkerIds.add(markerIdValue);
      final markerId = MarkerId(markerIdValue);
      markers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(driverNearby.lat!, driverNearby.lon!),
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        visible: true,
      );
    }

    final staleMarkerIds = markers.keys.where(
      (markerId) =>
          markerId.value.contains('driver_nearby_') &&
          !activeMarkerIds.contains(markerId.value),
    );

    if (staleMarkerIds.isEmpty) return;

    // Reset pinpoint so Animarker treats removed drivers as new marker ids.
    idPinpoint.value = const Uuid().v4();
    for (final staleMarkerId in staleMarkerIds) {
      markers.remove(staleMarkerId);
    }

    for (final driverNearby in driverNearbyList) {
      if (driverNearby.lat == null || driverNearby.lon == null) continue;

      final markerId = MarkerId(
        'driver_nearby_${driverNearby.driverId}_${idPinpoint.value}',
      );
      markers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(driverNearby.lat!, driverNearby.lon!),
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        visible: true,
      );
    }
  }

  Future<void> refreshMarkerDriverNearby() async {
    if (type.value != 'origin' ||
        isClosed ||
        _isDriverNearbyRefreshInProgress) {
      return;
    }

    _isDriverNearbyRefreshInProgress = true;
    try {
      await getDriverNearByList();
      if (isClosed) return;

      final icon = await _getDriverNearbyIcon();
      if (isClosed) return;

      _syncDriverNearbyMarkers(icon);
      markers.refresh();
    } finally {
      _isDriverNearbyRefreshInProgress = false;
    }
  }

  void enableDriverNearbyTimer() {
    if (type.value != 'origin') return;

    disableDriverNearbyTimer();
    _scheduleNextDriverNearbyRefresh();
  }

  void _scheduleNextDriverNearbyRefresh() {
    driverNearbyTimer = Timer(const Duration(seconds: 5), () async {
      if (isClosed || type.value != 'origin') return;

      await refreshMarkerDriverNearby();
      if (!isClosed && type.value == 'origin') {
        _scheduleNextDriverNearbyRefresh();
      }
    });
  }

  void disableDriverNearbyTimer() {
    driverNearbyTimer?.cancel();
    driverNearbyTimer = null;
  }

  Future<void> fillForm() async {
    type.value = Get.arguments?['type'];

    address.value = Get.arguments?['address'];
    addressName.value = Get.arguments?['address_name'];
    latitude.value = Get.arguments?['latitude'];
    longitude.value = Get.arguments?['longitude'];
    title.value = Get.arguments?['title'];
    pickupNote.value = Get.arguments?['pickup_note'];
    noteTextEditingController.text = pickupNote.value ?? "";

    if (latitude.value != null) {
      var searchedAddress = await geocodingRepository
          .getAddressByLatitudeLongitude(
            latitude: double.parse(latitude.value!),
            longitude: double.parse(longitude.value!),
          );
      if (isClosed) return;

      address.value = searchedAddress?.address ?? "-";
      addressName.value = searchedAddress?.name ?? "-";
      await moveGoogleMapCameraToFillLocation();
    } else {
      await moveGoogleMapCameraToCurrentLocation();
      if (isClosed) return;

      var searchedAddress = await geocodingRepository
          .getAddressByLatitudeLongitude(
            latitude: double.parse(latitude.value!),
            longitude: double.parse(longitude.value!),
          );
      if (isClosed) return;

      address.value = searchedAddress?.address ?? "-";
      addressName.value = searchedAddress?.name ?? "-";
    }
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

  void updateLocationLatLng({
    required double? latitude,
    required double? longitude,
  }) {
    if (latitude == null || longitude == null) return;

    final generation = _locationUpdateGeneration;
    _locationUpdateDebounceTimer?.cancel();
    isFetchAddress.value = true;

    _locationUpdateDebounceTimer = Timer(const Duration(seconds: 1), () async {
      if (_isLocationUpdateStale(generation)) {
        isFetchAddress.value = false;
        return;
      }

      final lat = latitude;
      final lng = longitude;
      if (lat.toString() != this.latitude.value ||
          lng.toString() != this.longitude.value) {
        isFetchAddress.value = false;
        return;
      }

      this.latitude.value = lat.toString();
      this.longitude.value = lng.toString();

      await Future.wait([
        setAddressAndAddressName(latitude: lat, longitude: lng),
        getRecommendationLocationList(),
      ]);

      if (_isLocationUpdateStale(generation)) {
        isFetchAddress.value = false;
        return;
      }

      if (recommendationLocationList.isEmpty) {
        isFetchAddress.value = false;
        return;
      }

      final nearestRecommendationLocation = getNearestRecommendationLocation(
        lat: lat,
        lng: lng,
      );

      if (_isLocationUpdateStale(generation)) {
        isFetchAddress.value = false;
        return;
      }

      final distanceMeter = Geolocator.distanceBetween(
        lat,
        lng,
        nearestRecommendationLocation.lat!,
        nearestRecommendationLocation.lng!,
      );

      if (distanceMeter <= 1) {
        await refreshPickupLocationMarkers();
        isFetchAddress.value = false;
        return;
      }

      await refreshPickupLocationMarkers();

      if (_isLocationUpdateStale(generation)) {
        isFetchAddress.value = false;
        return;
      }

      await _moveCameraProgrammatically(
        LatLng(
          nearestRecommendationLocation.lat!,
          nearestRecommendationLocation.lng!,
        ),
      );

      if (_isLocationUpdateStale(generation)) {
        isFetchAddress.value = false;
        return;
      }

      this.latitude.value = nearestRecommendationLocation.lat!.toString();
      this.longitude.value = nearestRecommendationLocation.lng!.toString();
      isFetchAddress.value = false;
    });
  }

  GeocodingPlaceWithPoints getNearestRecommendationLocation({
    required double lat,
    required double lng,
  }) {
    var nearestRecommendationLocation = recommendationLocationList.first;
    var nearestDistanceMeter = double.infinity;

    for (final recommendationLocation in recommendationLocationList) {
      if (recommendationLocation.lat == null ||
          recommendationLocation.lng == null) {
        continue;
      }

      final distanceMeter = Geolocator.distanceBetween(
        lat,
        lng,
        recommendationLocation.lat!,
        recommendationLocation.lng!,
      );

      recommendationLocation.customDistanceKm = distanceMeter / 1000;
      recommendationLocation.customDistanceM = distanceMeter;

      if (distanceMeter < nearestDistanceMeter) {
        nearestDistanceMeter = distanceMeter;
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
        "address":
            recommendationLocationList[selectedIndexRecommendationLocation
                    .value]
                .address,
        "address_name":
            recommendationLocationList[selectedIndexRecommendationLocation
                    .value]
                .name,
        "latitude":
            recommendationLocationList[selectedIndexRecommendationLocation
                    .value]
                .lat,
        "longitude":
            recommendationLocationList[selectedIndexRecommendationLocation
                    .value]
                .lng,
        "pickup_note": pickupNote.value,
      },
    );
  }

  Future<void> moveGoogleMapCameraToRecommendationLocation(int index) async {
    if (index < 0 || index >= recommendationLocationList.length) return;
    final location = recommendationLocationList[index];
    if (location.lat == null || location.lng == null) return;
    if (isClosed) return;

    _locationUpdateDebounceTimer?.cancel();
    _locationUpdateGeneration++;

    latitude.value = location.lat!.toString();
    longitude.value = location.lng!.toString();
    address.value =
        location.address ?? location.pointRecommendation?.address ?? "-";
    addressName.value =
        location.name ?? location.pointRecommendation?.name ?? "-";

    isRecommendationCameraMove.value = true;
    isMoveCameraFrom.value = "system";
    await (await googleMapController.future).animateCamera(
      CameraUpdate.newLatLng(LatLng(location.lat!, location.lng!)),
    );

    if (type.value == 'origin') {
      _updateNearestDistanceDriverNearbyFromCoordinates(
        lat: location.lat!,
        lon: location.lng!,
      );
    }
  }

  Future<void> refreshPickupLocationMarkers() async {
    _recommendationPinpointIcon ??= await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(25, 25)),
      'assets/icons/icon_recommendation_pinpoint.png',
    );

    removePickupLocationMarkers();

    // New uuid each refresh so Animarker recreates markers upright instead of
    // reusing tilted animation state from prior marker ids.
    final pickupPinpointId = const Uuid().v4();

    for (var index = 0; index < recommendationLocationList.length; index++) {
      final location = recommendationLocationList[index];
      if (location.lat == null || location.lng == null) continue;

      final markerId = MarkerId('pickup_location_${index}_$pickupPinpointId');
      markers[markerId] = Marker(
        markerId: markerId,
        position: LatLng(location.lat!, location.lng!),
        icon: _recommendationPinpointIcon!,
        anchor: const Offset(0.5, 0.5),
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
