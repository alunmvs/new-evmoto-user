import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class LoginRegisterController extends GetxController {
  final ThemeColorServices themeColorServices;
  final TypographyServices typographyServices;
  final LanguageServices languageServices;

  LoginRegisterController({
    ThemeColorServices? themeColorServices,
    TypographyServices? typographyServices,
    LanguageServices? languageServices,
  }) : themeColorServices =
           themeColorServices ?? Get.find<ThemeColorServices>(),
       typographyServices =
           typographyServices ?? Get.find<TypographyServices>(),
       languageServices = languageServices ?? Get.find<LanguageServices>();

  final loginRegisterFormKey = GlobalKey<FormState>();
  final mobileNumberTextEditingController = TextEditingController();

  final mobilePhone = "".obs;
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
    isFormValid.value =
        loginRegisterFormKey.currentState!.validate() &&
        mobilePhone.value != "";
  }

  Future<void> onTapSubmit() async {
    Get.toNamed(
      Routes.LOGIN_REGISTER_VERIFICATION_OTP,
      arguments: {
        "mobile_phone":
            "62${mobileNumberTextEditingController.text}".removeAllWhitespace,
      },
    );
    // SnackbarHelper.showSnackbarError(text: "test");
  }
}
