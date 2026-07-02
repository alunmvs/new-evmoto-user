import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';

class LoginRegisterController extends GetxController {
  final LoginRegisterRepository loginRegisterRepository;

  final ThemeColorServices themeColorServices;
  final TypographyServices typographyServices;
  final LanguageServices languageServices;

  LoginRegisterController({
    required this.loginRegisterRepository,
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
    mobilePhone.value = "";
    isFormValid.value = false;
    mobileNumberTextEditingController.clear();
    mobileNumberTextEditingController.addListener(validateForm);
  }

  @override
  void onClose() {
    mobileNumberTextEditingController.removeListener(validateForm);
    mobileNumberTextEditingController.dispose();
    super.onClose();
  }

  void validateForm() {
    final isValid = loginRegisterFormKey.currentState?.validate() ?? false;
    isFormValid.value = isValid && mobilePhone.value != "";
  }

  Future<void> onTapSubmit() async {
    var isPhoneRegistered = await loginRegisterRepository.checkPhoneRegistered(
      phone: mobilePhone.value,
    );

    if (isPhoneRegistered == false) {
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarPhoneNotRegistered ?? "-",
      );
      return;
    }

    Get.toNamed(
      Routes.LOGIN_REGISTER_VERIFICATION_OTP,
      arguments: {
        "mobile_phone":
            "62${mobileNumberTextEditingController.text}".removeAllWhitespace,
      },
    );
  }
}
