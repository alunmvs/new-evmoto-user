import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/login_register_controller.dart';

class LoginRegisterView extends GetView<LoginRegisterController> {
  const LoginRegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/logos/logo_evmoto.png",
            height: 27.87,
            width: 90,
          ),
          centerTitle: true,
          toolbarHeight: 56,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Stack(
          children: [
            Container(
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
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      controller.languageServices.language.value.loginTitle ??
                          "-",
                      style:
                          controller.typographyServices.headingSmallBold.value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .loginDescription ??
                          "-",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 22),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0XFF2D74BF),
                                    Color(0XFF114E8E),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  SizedBox(
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text:
                                                  "${controller.languageServices.language.value.tncPrivacyConfirmation1 ?? "-"} ",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .termAndCondition ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Get.toNamed(
                                                        Routes
                                                            .TERMS_AND_CONDITIONS,
                                                      );
                                                    },
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${controller.languageServices.language.value.tncPrivacyConfirmation2 ?? "-"} ",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .privacyPolicy ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Get.toNamed(
                                                            Routes
                                                                .PRIVACY_POLICY,
                                                          );
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${controller.languageServices.language.value.tncPrivacyConfirmation3 ?? "-"}",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller
                                          .themeColorServices
                                          .overlayDark100
                                          .value
                                          .withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .mobilePhone ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Form(
                                      key: controller.loginRegisterFormKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: controller
                                                .mobileNumberTextEditingController,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value,
                                            cursorErrorColor: controller
                                                .themeColorServices
                                                .primaryBlue
                                                .value,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                              hintText: '812345678xxxx',
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
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: controller
                                                          .themeColorServices
                                                          .sematicColorRed500
                                                          .value,
                                                    ),
                                                  ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey400
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              prefixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "+62",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onChanged: (value) {
                                              controller.mobilePhone.value =
                                                  value;
                                              controller.validateForm();
                                            },
                                            maxLength: 25,
                                            validator: (value) {
                                              if (value != null) {
                                                if (value.isNotEmpty) {
                                                  if (value.substring(0, 1) !=
                                                      "8") {
                                                    return 'Harus diawali dengan angka 8';
                                                  }
                                                }
                                                if (value.length < 8) {
                                                  return 'Minimal nomor handphone 8 angka';
                                                }
                                                if (value.length > 15) {
                                                  return 'Maksimal nomor handphone 15 angka';
                                                }
                                              }
                                              return null;
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          LoaderElevatedButton(
                                            onPressed:
                                                controller.isFormValid.value
                                                ? () async {
                                                    await controller
                                                        .onTapSubmit();
                                                  }
                                                : null,
                                            buttonColor:
                                                controller.isFormValid.value
                                                ? controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                            borderSide: BorderSide(
                                              color:
                                                  controller.isFormValid.value
                                                  ? controller
                                                        .themeColorServices
                                                        .sematicColorBlue200
                                                        .value
                                                  : controller
                                                        .themeColorServices
                                                        .neutralsColorGrey200
                                                        .value,
                                              width: 2,
                                            ),
                                            child: Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .loginButton ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 16),
                                    // Center(
                                    //   child: Text(
                                    //     controller
                                    //             .languageServices
                                    //             .language
                                    //             .value
                                    //             .loginOr ??
                                    //         "-",
                                    //     style: controller
                                    //         .typographyServices
                                    //         .bodySmallRegular
                                    //         .value
                                    //         .copyWith(
                                    //           color: controller
                                    //               .themeColorServices
                                    //               .neutralsColorGrey500
                                    //               .value,
                                    //         ),
                                    //   ),
                                    // ),

                                    // SizedBox(height: 16),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Container(
                                    //         width: MediaQuery.of(
                                    //           context,
                                    //         ).size.width,
                                    //         height: 48,
                                    //         decoration: BoxDecoration(
                                    //           border: Border.all(
                                    //             color: controller
                                    //                 .themeColorServices
                                    //                 .neutralsColorGrey200
                                    //                 .value,
                                    //           ),
                                    //           borderRadius:
                                    //               BorderRadius.circular(12),
                                    //         ),
                                    //         child: Center(
                                    //           child: SvgPicture.asset(
                                    //             "assets/logos/logo_facebook.svg",
                                    //             height: 24,
                                    //             width: 24,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: 16),
                                    //     Expanded(
                                    //       child: Container(
                                    //         width: MediaQuery.of(
                                    //           context,
                                    //         ).size.width,
                                    //         height: 48,
                                    //         decoration: BoxDecoration(
                                    //           border: Border.all(
                                    //             color: controller
                                    //                 .themeColorServices
                                    //                 .neutralsColorGrey200
                                    //                 .value,
                                    //           ),
                                    //           borderRadius:
                                    //               BorderRadius.circular(12),
                                    //         ),
                                    //         child: Center(
                                    //           child: SvgPicture.asset(
                                    //             "assets/logos/logo_google.svg",
                                    //             height: 24,
                                    //             width: 24,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
