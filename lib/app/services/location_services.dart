import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class LocationServices extends GetxService with WidgetsBindingObserver {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final geocodingAddress = GeocodingAddress().obs;

  final currentLatitude = Rx<double?>(null);
  final currentLongitude = Rx<double?>(null);
  final isPermissionLocationAllow = Rx<bool?>(null);

  final wasInBackground = false.obs;
  final isRequestingPermission = false.obs;
  final isRequiredAccessPermissionDialogActive = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      wasInBackground.value = true;
    }

    if (state == AppLifecycleState.resumed && wasInBackground.value == true) {
      await requestLocation();
      wasInBackground.value = false;
    }
  }

  Future<void> requestLocation() async {
    if (isRequestingPermission.value == false) {
      isRequestingPermission.value = true;
      isPermissionLocationAllow.value = true;
      var isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      var permission = await Geolocator.requestPermission();

      if (isLocationServiceEnabled == false ||
          (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever)) {
        isPermissionLocationAllow.value = false;
        isRequestingPermission.value = false;

        currentLatitude.value = null;
        currentLongitude.value = null;
        await showRequiredAccessPermission();
        return;
      }

      var locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      var position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      await getGeocodingAddress();
      isRequestingPermission.value = false;
    }
  }

  Future<void> getGeocodingAddress() async {
    if (currentLatitude.value != null) {
      var geocodingRepository = GeocodingRepository();
      var geocodingAddress =
          (await geocodingRepository.getAddressByLatitudeLongitude(
            latitude: currentLatitude.value,
            longitude: currentLongitude.value,
          )) ??
          GeocodingAddress();
      this.geocodingAddress.value = geocodingAddress;
    }
  }

  Future<void> openAppSettings() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> showRequiredAccessPermission() async {
    if (isRequiredAccessPermissionDialogActive.value == false) {
      isRequiredAccessPermissionDialogActive.value = true;
      await Get.dialog(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: themeColorServices.neutralsColorGrey0.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .locationAccessConsent ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.close(1);
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_close.svg",
                                      width: 18,
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 304.5 / 125,
                            child: Image.asset(
                              'assets/images/img_location_required.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          languageServices.language.value.needExactLocation ??
                              "-",
                          style: typographyServices.bodySmallRegular.value,
                        ),
                        SizedBox(height: 16),
                        LoaderElevatedButton(
                          child: Text(
                            languageServices.language.value.enableLocation ??
                                "-",
                            style: typographyServices.bodyLargeBold.value
                                .copyWith(
                                  color: themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                          ),
                          onPressed: () async {
                            await openAppSettings();
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
        ),
      );
      isRequiredAccessPermissionDialogActive.value = false;
    }
  }
}
