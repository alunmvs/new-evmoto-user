import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:new_evmoto_user/app/services/theme_color_services.dart';

String formatDouble(double value) {
  if (value == value.toInt()) {
    return value.toInt().toString();
  } else {
    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}

void showLoadingDialog() {
  var themeColorServices = Get.find<ThemeColorServices>();

  Get.dialog(
    PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: SizedBox(
                width: 70,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: themeColorServices.primaryBlue.value,
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
    barrierDismissible: false,
  );
}
