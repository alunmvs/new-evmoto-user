import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static showSnackbarSuccess({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    Get.snackbar(
      "",
      "",
      padding: EdgeInsets.all(16),
      snackStyle: SnackStyle.GROUNDED,
      titleText: const SizedBox(),
      messageText: Text(
        text,
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: themeColorServices.sematicColorGreen400.value,

      margin: const EdgeInsets.all(0),
    );
  }

  static showSnackbarError({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    Get.snackbar(
      "",
      "",
      padding: EdgeInsets.all(16),
      snackStyle: SnackStyle.GROUNDED,
      titleText: const SizedBox(),
      messageText: Text(
        text,
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: themeColorServices.sematicColorRed400.value,

      margin: const EdgeInsets.all(0),
    );
  }
}
