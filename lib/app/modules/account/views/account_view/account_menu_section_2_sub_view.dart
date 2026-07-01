import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/environment.dart';

import '../../../../routes/app_pages.dart';

class AccountMenuSection2SubView extends GetView<AccountController> {
  const AccountMenuSection2SubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey200.value,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                await controller.onTapContactCs();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_cs.svg",
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .customerService ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.TERMS_AND_CONDITIONS);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_docs.svg",
                            width: 14.22,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .termAndCondition ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.PRIVACY_POLICY);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_docs.svg",
                            width: 14.22,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .privacyPolicy ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // InkWell(
            //   onTap: () async {
            //     await controller.onTapRatingAndReviewApp();
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     color: Colors.transparent,
            //     child: Row(
            //       children: [
            //         Container(
            //           padding: EdgeInsets.all(4),
            //           decoration: BoxDecoration(
            //             color: controller
            //                 .themeColorServices
            //                 .sematicColorBlue100
            //                 .value,
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: SvgPicture.asset(
            //             "assets/icons/icon_star.svg",
            //             width: 16,
            //             height: 16,
            //             color: controller
            //                 .themeColorServices
            //                 .sematicColorBlue500
            //                 .value,
            //           ),
            //         ),
            //         SizedBox(width: 8),
            //         Text(
            //           controller
            //                   .languageServices
            //                   .language
            //                   .value
            //                   .rateUs ??
            //               "-",
            //           style: controller
            //               .typographyServices
            //               .bodySmallBold
            //               .value,
            //         ),
            //         Spacer(),
            //         Row(
            //           children: [
            //             SvgPicture.asset(
            //               "assets/icons/icon_arrow_right.svg",
            //               width: 6,
            //               height: 12,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () async {
                await controller.onTapCheckUpdate();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_refresh.svg",
                            width: 14.4,
                            height: 11.2,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .checkForUpdates ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isChuckerEnabled) ...[
              InkWell(
                onTap: () {
                  ChuckerFlutter.showChuckerScreen();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .sematicColorBlue100
                              .value,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_docs.svg",
                              width: 14.22,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                controller
                                    .themeColorServices
                                    .sematicColorBlue500
                                    .value,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Chucker Debug",
                        style:
                            controller.typographyServices.bodySmallBold.value,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_arrow_right.svg",
                            width: 6,
                            height: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
