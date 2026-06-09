import 'package:flutter_svg/svg.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/main.dart';

class SnackbarHelper {
  static showSnackbarSuccess({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    var snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/icons/icon_snackbar_success.svg"),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: Color(0XFF005216),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Icon(Icons.close, color: Color(0XFF005216), size: 20),
          ),
        ],
      ),
      closeIconColor: Color(0XFF005216),
      showCloseIcon: false,
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 12),
      margin: EdgeInsets.only(bottom: 14, left: 12, right: 12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0XFFE1FFE9),
      elevation: 0,
    );

    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static showSnackbarError({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    var snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset("assets/icons/icon_snackbar_error.svg"),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: Color(0XFFCD0000),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
            child: Icon(Icons.close, color: Color(0XFFCD0000), size: 20),
          ),
        ],
      ),
      closeIconColor: Color(0XFFCD0000),
      showCloseIcon: false,
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 12),
      margin: EdgeInsets.only(bottom: 14, left: 12, right: 12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0XFFFFEBEB),
      elevation: 0,
    );

    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
