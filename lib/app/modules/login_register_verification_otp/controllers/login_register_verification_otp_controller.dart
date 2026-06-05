import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/main.dart';

class LoginRegisterVerificationOtpController extends GetxController {
  final OtpRepository otpRepository;
  final LoginRegisterRepository loginRegisterRepository;

  LoginRegisterVerificationOtpController({
    required this.otpRepository,
    required this.loginRegisterRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();
  final userServices = Get.find<UserServices>();

  final isOTPInvalid = false.obs;

  final mobilePhone = "".obs;
  final otpCode = "".obs;

  final otpProtectionTimerSeconds = 0.obs;
  Timer? otpProtectionTimer;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    mobilePhone.value = Get.arguments['mobile_phone'] ?? "";
    isFetch.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await requestOTP();
    });
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
        language: languageServices.languageCodeSystem.value,
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
      SnackbarHelper.showSnackbarSuccess(
        text: languageServices.language.value.snackbarOtpSuccess ?? "-",
      );
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> onSubmitOTP() async {
    try {
      await locationServices.requestLocation(isSkipGeocodingAddress: true);
      if (locationServices.currentLatitude.value != null) {
        var loginData = await loginRegisterRepository.loginByOtp(
          phone: mobilePhone.value,
          code: otpCode.value,
          language: languageServices.languageCodeSystem.value,
          lat: locationServices.currentLatitude.value.toString(),
          lng: locationServices.currentLongitude.value.toString(),
        );
        var storage = FlutterSecureStorage();
        await storage.write(key: "token", value: loginData.token);
        await userServices.getUserInfo();

        Get.offAllNamed(Routes.HOME);
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }
}
