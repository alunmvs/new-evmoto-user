import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/dialog_helper.dart';
import 'package:new_evmoto_user/app/utils/dialog_tags.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';

class AdvancedBookingCreatedDialog extends StatelessWidget {
  final Function onTapConfirm;

  AdvancedBookingCreatedDialog({super.key, required this.onTapConfirm});

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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              languageServices
                                      .language
                                      .value
                                      .advancedBookingCreatedTitle ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DialogHelper.dismiss(
                                DialogTags.advancedBookingCreated,
                              );
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
                        ],
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/img_advance_booking_created.png",
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        languageServices
                                .language
                                .value
                                .advancedBookingCreatedDescription ??
                            "-",
                        style: typographyServices.bodySmallRegular.value
                            .copyWith(color: Color(0XFFB3B3B3)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        buttonColor: themeColorServices.primaryBlue.value,
                        onPressed: () async {
                          await onTapConfirm();
                        },
                        child: Text(
                          languageServices
                                  .language
                                  .value
                                  .advancedBookingCreatedButton ??
                              "-",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
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
