import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart'
    hide Routes;
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';

import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';

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

Future<void> clearDataLogout() async {
  final socketServices = Get.find<SocketServices>();
  final firebasePushNotificationServices =
      Get.find<FirebasePushNotificationServices>();
  var storage = FlutterSecureStorage();

  await Future.wait([
    firebasePushNotificationServices.onUnsubscribe(),
    storage.deleteAll(),
    socketServices.closeWebsocket(),
  ]);
}

Future<void> logout() async {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final socketServices = Get.find<SocketServices>();
  final firebasePushNotificationServices =
      Get.find<FirebasePushNotificationServices>();
  var storage = FlutterSecureStorage();

  await Future.wait([
    firebasePushNotificationServices.onUnsubscribe(),
    storage.deleteAll(),
    socketServices.closeWebsocket(),
  ]);

  Get.offAllNamed(Routes.LOGIN_REGISTER);

  var snackBar = SnackBar(
    behavior: SnackBarBehavior.fixed,
    backgroundColor: themeColorServices.sematicColorGreen400.value,
    content: Text(
      languageServices.language.value.snackbarLogoutSuccess ?? "-",
      style: typographyServices.bodySmallRegular.value.copyWith(
        color: themeColorServices.neutralsColorGrey0.value,
      ),
    ),
  );
  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
