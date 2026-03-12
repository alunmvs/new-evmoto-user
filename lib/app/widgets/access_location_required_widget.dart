import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class AccessLocationRequiredWidget extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  AccessLocationRequiredWidget({super.key, required this.onRefresh});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/img_location.png",
              width: 375,
              height: 100,
            ),
            SizedBox(height: 26),
            Text(
              'Persetujuan Akses Lokasi',
              style: typographyServices.bodyLargeBold.value,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Lokasi digunakan untuk menampilkan fitur dan layanan berdasarkan posisi Anda saat ini.',
              style: typographyServices.bodySmallRegular.value,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 26),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: () async {
                  await checkAndEnableLocation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColorServices.primaryBlue.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                  padding: EdgeInsets.all(0),
                ),
                child: Text(
                  'Aktifkan Lokasi',
                  style: typographyServices.bodyLargeBold.value.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (onRefresh != null) ...[
              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    await onRefresh!();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: themeColorServices.primaryBlue.value,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Refresh',
                    style: typographyServices.bodyLargeBold.value.copyWith(
                      color: themeColorServices.primaryBlue.value,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
