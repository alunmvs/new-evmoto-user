import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';

import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime parseTime(String time) {
  final parts = time.split(':');
  final now = DateTime.now();

  return DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

String formatDistance(double meters) {
  if (meters >= 1000) {
    double km = meters / 1000;

    String kmStr = km.toStringAsFixed(2);
    kmStr = kmStr.replaceAll(RegExp(r'\.?0+$'), '');

    return '$kmStr km';
  } else {
    String mStr = meters.toStringAsFixed(2);
    mStr = mStr.replaceAll(RegExp(r'\.?0+$'), '');

    return '$mStr m';
  }
}

String formatDistanceNearestDriver(
  double meters,
  String? nearestDriverAvailable2,
) {
  if (meters >= 1000) {
    double km = meters / 1000;

    String kmStr = km.toStringAsFixed(2);
    kmStr = kmStr.replaceAll(RegExp(r'\.?0+$'), '');

    return '$kmStr km$nearestDriverAvailable2';
  } else {
    String mStr = meters.toStringAsFixed(2);
    mStr = mStr.replaceAll(RegExp(r'\.?0+$'), '');

    return '$mStr m$nearestDriverAvailable2';
  }
}

Future<void> clearDataLogout() async {
  final homeController = Get.find<HomeController>();
  final activityController = Get.find<ActivityController>();
  final accountController = Get.find<AccountController>();
  final socketServices = Get.find<SocketServices>();
  final firebasePushNotificationServices =
      Get.find<FirebasePushNotificationServices>();
  final userServices = Get.find<UserServices>();
  var storage = FlutterSecureStorage();
  var prefs = await SharedPreferences.getInstance();

  // final sendbirdServices = Get.find<SendbirdServices>();
  // final sendbirdChatServices = Get.find<SendbirdChatServices>();

  try {
    if (userServices.isLoadingRefreshHome.value == true) {
      await userServices.isLoadingRefreshHome.stream.firstWhere(
        (value) => value == false,
      );
    }

    if (homeController.isRefreshAllLoading.value == true) {
      await homeController.isRefreshAllLoading.stream.firstWhere(
        (value) => value == false,
      );
    }

    homeController.disableDriverNearbyTimer();

    // if (sendbirdChatServices.isSuccessInitialize.value == false) {
    //   await sendbirdChatServices.isSuccessInitialize.stream.firstWhere(
    //     (value) => value == true,
    //   );
    // }

    // if (sendbirdServices.isSuccessInitialize.value == false) {
    //   await sendbirdServices.isSuccessInitialize.stream.firstWhere(
    //     (value) => value == true,
    //   );
    // }

    if (homeController.isFetch.value == true) {
      await homeController.isFetch.stream.firstWhere((value) => value == false);
    }

    if (activityController.isFetch.value == true) {
      await activityController.isFetch.stream.firstWhere(
        (value) => value == false,
      );
    }

    if (accountController.isFetch.value == true) {
      await accountController.isFetch.stream.firstWhere(
        (value) => value == false,
      );
    }

    await Future.wait([
      // sendbirdServices.clearLogout(),
      // sendbirdChatServices.clearLogout(),
      firebasePushNotificationServices.onUnsubscribe(),
      storage.delete(key: 'token'),
      socketServices.closeWebsocket(),
      prefs.clear(),
    ], eagerError: false);
    userServices.clearUserInfo();
  } on DioException catch (e) {
    SnackbarHelper.showSnackbarError(text: e.error.toString());
  } catch (e) {
    SnackbarHelper.showSnackbarError(text: e.toString());
  }
}

Future<void> logout() async {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  await clearDataLogout();

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
