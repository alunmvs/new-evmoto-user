import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:pinput/pinput.dart';

import '../controllers/login_register_verification_otp_controller.dart';

class LoginRegisterVerificationOtpView
    extends GetView<LoginRegisterVerificationOtpController> {
  const LoginRegisterVerificationOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.verificationOtpTitle ??
                "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        resizeToAvoidBottomInset: true,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      SvgPicture.asset(
                        "assets/images/img_otp.svg",
                        width: 139,
                        height: 80,
                      ),
                      SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text:
                              "${controller.languageServices.language.value.verificationOtpDescription ?? "-"} ",
                          style: controller
                              .typographyServices
                              .bodyLargeRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey600
                                    .value,
                              ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "+${controller.mobilePhone.value}",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Pinput(
                        defaultPinTheme: PinTheme(
                          textStyle: controller
                              .typographyServices
                              .headingMediumBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                          width: 48,
                          height: 52 + 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                          ),
                        ),
                        onCompleted: (pin) async {
                          controller.otpCode.value = pin;
                          await controller.onSubmitOTP();
                        },
                      ),
                      if (controller.isOTPInvalid.value == true) ...[
                        SizedBox(height: 16),
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .verificationOtpNotMatch ??
                              "-",
                          style: controller
                              .typographyServices
                              .bodyLargeRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: controller.isFetch.value
            ? null
            : Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BottomAppBar(
                  padding: EdgeInsets.all(0),
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  child: Column(
                    children: [
                      DashedLine(
                        height: 0,
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey200
                            .value,
                      ),
                      Expanded(
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "${controller.languageServices.language.value.verificationOtpNotReceive ?? "-"} ",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey700
                                        .value,
                                  ),
                              children: <TextSpan>[
                                if (controller
                                        .otpProtectionTimerSeconds
                                        .value ==
                                    0) ...[
                                  TextSpan(
                                    text:
                                        controller
                                            .languageServices
                                            .language
                                            .value
                                            .verificationOtpResend ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await controller.requestOTP();
                                      },
                                  ),
                                ],
                                if (controller
                                        .otpProtectionTimerSeconds
                                        .value !=
                                    0) ...[
                                  TextSpan(
                                    text:
                                        '(${controller.otpProtectionTimerSeconds.value.toString()})',
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                  ),
                                ],
                              ],
                            ),
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
