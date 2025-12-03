import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class LoginRegisterController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final loginRegisterFormKey = GlobalKey<FormState>();
  final mobileNumberTextEditingController = TextEditingController();

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobileNumberTextEditingController.addListener(validateForm);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void validateForm() {
    isFormValid.value = loginRegisterFormKey.currentState!.validate();
  }

  Future<void> onTapSubmit() async {
    Get.toNamed(
      Routes.LOGIN_REGISTER_VERIFICATION_OTP,
      arguments: {
        "mobile_phone":
            "62${mobileNumberTextEditingController.text}".removeAllWhitespace,
      },
    );
  }
}
