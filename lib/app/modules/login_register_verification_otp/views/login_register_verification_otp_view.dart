import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

import '../controllers/login_register_verification_otp_controller.dart';

class LoginRegisterVerificationOtpView
    extends GetView<LoginRegisterVerificationOtpController> {
  const LoginRegisterVerificationOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi OTP',
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
                  text: 'Kami telah mengirimkan 6 digit OTP ke nomor ',
                  style: controller.typographyServices.bodyLargeRegular.value,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+6281234567890',
                      style: controller.typographyServices.bodyLargeBold.value,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              OtpTextField(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                numberOfFields: 6,
                autoFocus: true,
                borderColor:
                    controller.themeColorServices.neutralsColorGrey400.value,
                focusedBorderColor: controller.isOTPInvalid.value
                    ? controller.themeColorServices.sematicColorRed500.value
                    : controller.themeColorServices.primaryBlue.value,
                enabledBorderColor: controller.isOTPInvalid.value
                    ? controller.themeColorServices.sematicColorRed500.value
                    : controller.themeColorServices.primaryBlue.value,
                showFieldAsBox: true,
                fieldHeight: 52 + 5,
                fieldWidth: 48,
                borderWidth: 1,
                borderRadius: BorderRadius.circular(8),
                textStyle:
                    controller.typographyServices.headingMediumBold.value,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) async {
                  await controller.onSubmitOTP();
                },
              ),
              SizedBox(height: 16),
              Text(
                "Kode yang anda masukkan salah",
                style: controller.typographyServices.bodyLargeRegular.value
                    .copyWith(
                      color: controller
                          .themeColorServices
                          .sematicColorRed500
                          .value,
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
              Expanded(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Tidak Menerima Kode? ",
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
                        TextSpan(
                          text: '(20)',
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
