import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OnboardingRegistrationFormController extends GetxController {
  final UserRepository userRepository;

  OnboardingRegistrationFormController({required this.userRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final userServices = Get.find<UserServices>();

  final formGroup = FormGroup({
    "full_name": FormControl<String>(
      validators: <Validator>[Validators.required, Validators.maxLength(20)],
    ),
  });

  final userInfo = UserInfo().obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getUserInfo();
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

  Future<void> getUserInfo() async {
    userInfo.value = (await userRepository.getUserInfo(
      language: languageServices.languageCodeSystem.value,
    ));
  }

  Future<void> onTapLogout() async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        languageServices.language.value.logoutConfirmation ??
                            "-",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  languageServices.language.value.cancel ?? "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: LoaderElevatedButton(
                              onPressed: () async {
                                var storage = FlutterSecureStorage();
                                await storage.delete(key: 'token');

                                Get.offAllNamed(Routes.LOGIN_REGISTER);

                                SnackbarHelper.showSnackbarSuccess(
                                  text:
                                      languageServices
                                          .language
                                          .value
                                          .snackbarLogoutSuccess ??
                                      "-",
                                );
                              },
                              buttonColor:
                                  themeColorServices.sematicColorRed400.value,
                              child: Text(
                                languageServices.language.value.logout ?? "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                        ],
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
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      await userRepository.updateName(
        name: formGroup.control("full_name").value,
        id: userInfo.value.id!,
      );

      await userServices.getUserInfo();

      Get.offAllNamed(Routes.HOME);
    } else {
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarRequiredNotSuccess ?? "-",
      );
      return;
    }
  }
}
