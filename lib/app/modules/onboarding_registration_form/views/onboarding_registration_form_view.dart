import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/onboarding_registration_form_controller.dart';

class OnboardingRegistrationFormView
    extends GetView<OnboardingRegistrationFormController> {
  const OnboardingRegistrationFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop == false) {
            await controller.onTapLogout();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            surfaceTintColor:
                controller.themeColorServices.neutralsColorGrey0.value,
          ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          body: controller.isFetch.value
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ReactiveForm(
                      formGroup: controller.formGroup,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 323 / 220,
                            child: Image.asset(
                              "assets/images/img_input_form_name.png",
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Siapa Nama Kamu?",
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value
                                .copyWith(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Agar kami dapat memberikan layanan terbaik untuk kamu.",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(color: Color(0XFF818181)),
                          ),
                          SizedBox(height: 8),
                          ReactiveTextField(
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                            cursorErrorColor:
                                controller.themeColorServices.primaryBlue.value,
                            formControlName: 'full_name',
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                              prefix: SizedBox(width: 12),
                              suffix: SizedBox(width: 12),
                              hintText:
                                  controller
                                      .languageServices
                                      .language
                                      .value
                                      .enterName ??
                                  "-",
                              hintStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                              errorStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validationMessages: {
                              ValidationMessage.required: (error) =>
                                  'Wajib diisi',
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            height: 78,
            shadowColor: controller.themeColorServices.overlayDark100.value
                .withValues(alpha: 0.1),
            color: controller.themeColorServices.neutralsColorGrey0.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 46,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.onTapSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.themeColorServices.primaryBlue.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      controller.languageServices.language.value.save ?? "-",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
