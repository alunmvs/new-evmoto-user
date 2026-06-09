import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';

class AdvancedBookingExpiredDialog extends StatelessWidget {
  final Function onTapConfirm;

  AdvancedBookingExpiredDialog({super.key, required this.onTapConfirm});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(
                  navigatorKey.currentContext!,
                ).size.height,
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/icon_advance_order_expired_dialog.png",
                                  width: 52,
                                  height: 52,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.close(1);
                              },
                              child: Container(
                                color: Colors.transparent,
                                width: 24,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_close.svg",
                                      width: 18,
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        languageServices
                                .language
                                .value
                                .advancedBookingExpiredTitle ??
                            "-",
                        style: typographyServices.bodyLargeBold.value,
                      ),
                      SizedBox(height: 8),
                      Text(
                        languageServices
                                .language
                                .value
                                .advancedBookingExpiredlDescription ??
                            "-",
                        style: typographyServices.bodySmallRegular.value
                            .copyWith(color: Color(0XFFB3B3B3)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            height: 46,
                            width: 110,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0XFFAFAFAF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                Get.close(1);
                              },
                              child: Text(
                                languageServices
                                        .language
                                        .value
                                        .advancedBookingExpiredButtonBack ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(color: Color(0XFFAFAFAF)),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: LoaderElevatedButton(
                              buttonColor: themeColorServices.primaryBlue.value,
                              onPressed: () async {
                                await onTapConfirm();
                              },
                              child: Text(
                                languageServices
                                        .language
                                        .value
                                        .advancedBookingExpiredButtonConfirm ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
