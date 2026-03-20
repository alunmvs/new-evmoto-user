import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class AccessLocationRequiredDialog extends StatelessWidget {
  AccessLocationRequiredDialog({super.key});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  Future<void> checkAndEnableLocation() async {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          "Persetujuan Akses Lokasi",
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
                                  width: 12,
                                  height: 12,
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
                      "Kami membutuhkan lokasi Anda yang tepat agar dapat melayani Anda dengan lebih baik.",
                      style: typographyServices.bodySmallRegular.value,
                    ),
                    SizedBox(height: 16),
                    LoaderElevatedButton(
                      child: Text(
                        "Aktifkan Lokasi",
                        style: typographyServices.bodyLargeBold.value.copyWith(
                          color: themeColorServices.neutralsColorGrey0.value,
                        ),
                      ),
                      onPressed: () async {
                        await checkAndEnableLocation();
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
