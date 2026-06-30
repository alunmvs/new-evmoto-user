import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kembali",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        automaticallyImplyLeading: true,
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ReactiveForm(
            formGroup: controller.formGroup,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/img_register.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Daftar Akun",
                  style: controller.typographyServices.headingSmallBold.value
                      .copyWith(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Nomor Telepon",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFF7D7D7D)),
                    ),
                    Text(
                      "*",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFFE11C0B)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ReactiveTextField(
                  style: controller.typographyServices.bodySmallRegular.value,
                  cursorErrorColor:
                      controller.themeColorServices.primaryBlue.value,
                  formControlName: 'mobile_number',
                  maxLines: 1,
                  validationMessages: {
                    ValidationMessage.required: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .requiredFields ??
                        "-",
                    ValidationMessage.minLength: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .min8DigitMobilePhone ??
                        "-",
                    ValidationMessage.maxLength: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .max15DigitMobilePhone ??
                        "-",
                    ValidationMessage.pattern: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .mustStartWith8 ??
                        "-",
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 12,
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
                    hintText:
                        controller
                            .languageServices
                            .language
                            .value
                            .enterMobileNumber ??
                        '812345678594',
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
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Nama Lengkap",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFF7D7D7D)),
                    ),
                    Text(
                      "*",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFFE11C0B)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ReactiveTextField(
                  style: controller.typographyServices.bodySmallRegular.value,
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
                            .enterFullName ??
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
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .requiredFields ??
                        "-",
                    ValidationMessage.maxLength: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .maxCharacter20 ??
                        "-",
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Kode OTP",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFF7D7D7D)),
                    ),
                    Text(
                      "*",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFFE11C0B)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ReactiveTextField(
                  style: controller.typographyServices.bodySmallRegular.value,
                  cursorErrorColor:
                      controller.themeColorServices.primaryBlue.value,
                  formControlName: 'otp_code',
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validationMessages: {
                    ValidationMessage.required: (error) =>
                        controller
                            .languageServices
                            .language
                            .value
                            .requiredFields ??
                        "-",
                    ValidationMessage.maxLength: (error) =>
                        "Kode OTP harus terdiri dari 4 huruf",
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 12,
                    ),
                    prefix: SizedBox(width: 12),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        await controller.onTapRequestOTP();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          "Request OTP",
                          style: controller
                              .typographyServices
                              .bodySmallBold
                              .value
                              .copyWith(color: Color(0XFF272727)),
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    hintText:
                        controller
                            .languageServices
                            .language
                            .value
                            .enterOtpCode ??
                        "Masukkan kode OTP",
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
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Kode Referral",
                      style: controller
                          .typographyServices
                          .bodyLargeRegular
                          .value
                          .copyWith(color: Color(0XFF7D7D7D)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ReactiveTextField(
                  style: controller.typographyServices.bodySmallRegular.value,
                  cursorErrorColor:
                      controller.themeColorServices.primaryBlue.value,
                  formControlName: 'referral_code',
                  keyboardType: TextInputType.text,
                  maxLength: 8,
                  validationMessages: {
                    ValidationMessage.maxLength: (error) =>
                        "Kode referral harus terdiri dari 8 huruf",
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 12,
                    ),
                    prefix: SizedBox(width: 12),
                    suffix: SizedBox(width: 12),
                    hintText: "Masukkan kode referral",
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
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Scan formulir yang telah terisi otomatis, ketuk untuk mengedit atau memasukkan kode secara manual.",
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(color: Color(0XFFB3B3B3)),
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
            LoaderElevatedButton(
              onPressed: () async {
                await controller.onTapSubmit();
              },
              child: Text(
                "Create Account",
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
