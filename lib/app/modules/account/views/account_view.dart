import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
          ),
          RefreshIndicator(
            color: controller.themeColorServices.primaryBlue.value,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            onRefresh: () async {
              await controller.homeController.refreshAll();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 11.5,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_profile_filled.svg",
                            width: 48,
                            height: 48,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.homeController.userInfo.value.name ??
                                    "-",
                                style: controller
                                    .typographyServices
                                    .bodyLargeBold
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey700
                                          .value,
                                    ),
                              ),
                              Text(
                                "+${controller.homeController.userInfo.value.phone ?? "-"}",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey500
                                          .value,
                                    ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: controller
                          //         .themeColorServices
                          //         .sematicColorBlue100
                          //         .value,
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: SvgPicture.asset(
                          //     "assets/icons/icon_edit.svg",
                          //     width: 16,
                          //     height: 16,
                          //     color: controller
                          //         .themeColorServices
                          //         .sematicColorBlue500
                          //         .value,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.SETTING_LANGUAGE);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_language.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .settingLanguage ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      if (controller
                                              .languageServices
                                              .languageCode
                                              .value ==
                                          "ZH_CN") ...[
                                        SvgPicture.asset(
                                          "assets/icons/icon_flag_cn.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                      if (controller
                                              .languageServices
                                              .languageCode
                                              .value ==
                                          "EN") ...[
                                        SvgPicture.asset(
                                          "assets/icons/icon_flag_en.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                      if (controller
                                              .languageServices
                                              .languageCode
                                              .value ==
                                          "ID") ...[
                                        SvgPicture.asset(
                                          "assets/icons/icon_flag_id.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],

                                      SizedBox(width: 13),
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
                          //   onTap: () {
                          //     Get.toNamed(Routes.SETTING_PAYMENT);
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
                          //             "assets/icons/icon_wallet.svg",
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
                          //                   .settingPayment ??
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
                            onTap: () {
                              Get.toNamed(Routes.SETTING_SAVED_LOCATION);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_save.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .settingSavedLocation ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
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
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_cs.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
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
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
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
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_docs.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
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
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
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
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_docs.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
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
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
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
                            onTap: () async {
                              await controller.onTapRatingAndReviewApp();
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_star.svg",
                                      width: 16,
                                      height: 16,
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .rateUs ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await controller.onTapManageAccount();
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_logout.svg",
                                    width: 16,
                                    height: 16,
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Kelola Akun",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorRed400
                                              .value,
                                        ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey200
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "${controller.languageServices.language.value.appVersion ?? "-"} v${controller.packageVersion.value}",
                                          style: controller
                                              .typographyServices
                                              .captionSmallBold
                                              .value,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
