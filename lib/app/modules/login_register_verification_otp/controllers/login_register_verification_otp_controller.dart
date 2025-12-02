import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class LoginRegisterVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final LoginRegisterRepository loginRegisterRepository;

  LoginRegisterVerificationOtpController({
    required this.otpRepository,
    required this.loginRegisterRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final isOTPInvalid = false.obs;

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final latitude = "".obs;
  final longitude = "".obs;

  final otpProtectionTimerSeconds = 0.obs;
  late Timer? otpProtectionTimer;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments['mobile_phone'] ?? "";
    await requestLocation();
    await requestOTP();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> requestOTP() async {
    try {
      await otpRepository.requestOTP(
        language: 2,
        phone: mobilePhone.value,
        type: 2,
      );

      otpProtectionTimerSeconds.value = 60;
      otpProtectionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (otpProtectionTimerSeconds.value == 0) {
          otpProtectionTimer?.cancel();
        } else {
          otpProtectionTimerSeconds.value -= 1;
        }
      });
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> requestLocation() async {
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      return;
    }

    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
  }

  Future<void> onSubmitOTP() async {
    try {
      var loginData = await loginRegisterRepository.loginByOtp(
        phone: mobilePhone.value,
        code: otpCode.value,
        language: 2,
        lat: latitude.value,
        lng: longitude.value,
      );

      var storage = FlutterSecureStorage();
      await storage.write(key: "token", value: loginData.token);

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(message: e.toString(), duration: Duration(seconds: 2)),
      );
    }
  }
}
