import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class CreateOrderRideMapSelectController extends GetxController {
  final GeocodingRepository geocodingRepository;

  CreateOrderRideMapSelectController({required this.geocodingRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final type = Rx<String?>(null);

  final address = Rx<String?>(null);
  final addressName = Rx<String?>(null);
  final latitude = Rx<String?>(null);
  final longitude = Rx<String?>(null);

  final isPermissionLocationAllow = false.obs;
  final isFetchAddress = false.obs;
  final isFetch = true.obs;

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
  }

  Future<void> fillForm() async {
    type.value = Get.arguments?['type'];

    address.value = Get.arguments?['address'];
    addressName.value = Get.arguments?['address_name'];
    latitude.value = Get.arguments?['latitude'];
    longitude.value = Get.arguments?['longitude'];

    print("ini get arguments ${Get.arguments}");

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

      googleMapController.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(latitude.value!), double.parse(longitude.value!)),
        ),
      );
    } else {
      // default
      latitude.value = "-6.1744651";
      longitude.value = "106.822745";

      googleMapController.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(latitude.value!), double.parse(longitude.value!)),
        ),
      );
    }
  }

  Future<void> moveGoogleMapCameraToFillLocation() async {
    if (latitude.value != null && longitude.value != null) {
      await googleMapController.moveCamera(
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
        var searchedAddress = await geocodingRepository
            .getAddressByLatitudeLongitude(
              latitude: latitude,
              longitude: longitude,
            );
        address.value = searchedAddress?.address ?? "-";
        addressName.value = searchedAddress?.name ?? "-";
        this.latitude.value = latitude.toString();
        this.longitude.value = longitude.toString();
        isFetchAddress.value = false;
      }
    });
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
}
