import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              if (controller.indexNavigationBar.value == 0) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: SvgPicture.asset(
                    "assets/logos/logo_evmoto.svg",
                    width: 63.86,
                    height: 19.77,
                  ),
                ),
              ],
              if (controller.indexNavigationBar.value == 1) ...[
                Text(
                  controller.languageServices.language.value.activity ?? "-",
                  style: controller.typographyServices.headingSmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              ],
              if (controller.indexNavigationBar.value == 2) ...[
                Text(
                  controller.languageServices.language.value.account ?? "-",
                  style: controller.typographyServices.headingSmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              ],
            ],
          ),
          centerTitle: true,
          backgroundColor: controller.themeColorServices.primaryBlue.value,
        ),
        backgroundColor: controller.indexNavigationBar.value == 0
            ? controller.themeColorServices.neutralsColorGrey0.value
            : controller.themeColorServices.primaryBlue.value,
        body: Column(
          children: [
            if (controller.indexNavigationBar.value == 0) ...[
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                    RefreshIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                      backgroundColor: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      onRefresh: () async {
                        await controller.refreshAll();
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.25,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0XFF0060C6),
                                        Color(0XFF004084),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 16),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 16),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .homeRideReadyToGoTitle ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey600
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapRideService();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey100
                                                      .value,
                                                  border: Border.all(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey300
                                                        .value,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_pinpoint.svg",
                                                      width: 18,
                                                      height: 21,
                                                    ),
                                                    SizedBox(width: 11),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .homeRideReadyToGoHint ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        Routes.SEARCH_ADDRESS,
                                                        arguments: {
                                                          "address_type": 1,
                                                        },
                                                      );

                                                      // Get.toNamed(
                                                      //   Routes.ADD_EDIT_ADDRESS,
                                                      //   arguments: {
                                                      //     "address_type": "home",
                                                      //   },
                                                      // );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_home.svg",
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            controller
                                                                    .languageServices
                                                                    .language
                                                                    .value
                                                                    .addLocationHome ??
                                                                "-",
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
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        Routes.SEARCH_ADDRESS,
                                                        arguments: {
                                                          "address_type": 2,
                                                        },
                                                      );

                                                      // Get.toNamed(
                                                      //   Routes.ADD_EDIT_ADDRESS,
                                                      //   arguments: {
                                                      //     "address_type": "office",
                                                      //   },
                                                      // );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_office.svg",
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            controller
                                                                    .languageServices
                                                                    .language
                                                                    .value
                                                                    .addLocationOffice ??
                                                                "-",
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
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        Routes.SEARCH_ADDRESS,
                                                        arguments: {
                                                          "address_type": 3,
                                                        },
                                                      );

                                                      // Get.toNamed(
                                                      //   Routes.ADD_EDIT_ADDRESS,
                                                      //   arguments: {
                                                      //     "address_type": "other",
                                                      //   },
                                                      // );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_add_square.svg",
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            controller
                                                                    .languageServices
                                                                    .language
                                                                    .value
                                                                    .addLocationOther ??
                                                                "-",
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
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Divider(
                                              height: 0,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey100
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 22),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: GridView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                                childAspectRatio:
                                                    104 / (97 + 20),
                                              ),
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapRideService();
                                              },
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      AspectRatio(
                                                        aspectRatio: 1 / 1,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                            context,
                                                          ).size.width,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey200
                                                                  .value,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_ride.svg",
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                controller
                                                                        .languageServices
                                                                        .language
                                                                        .value
                                                                        .delivery ??
                                                                    "-",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0XFF8FD9FA,
                                                                  ),
                                                                  Color(
                                                                    0XFFA1E2FB,
                                                                  ),
                                                                  Color(
                                                                    0XFFB5ECFC,
                                                                  ),
                                                                  Color(
                                                                    0XFFC2F2FD,
                                                                  ),
                                                                  Color(
                                                                    0XFFC6F4FD,
                                                                  ),
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              ),
                                                          border: Border.all(
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorBlue200
                                                                .value,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .discount50 ??
                                                              "-",
                                                          style: controller
                                                              .typographyServices
                                                              .captionSmallBold
                                                              .value
                                                              .copyWith(
                                                                color: controller
                                                                    .themeColorServices
                                                                    .sematicColorBlue500
                                                                    .value,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes
                                                      .INTRODUCTION_PACKAGE_SERVICE,
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      AspectRatio(
                                                        aspectRatio: 1 / 1,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                            context,
                                                          ).size.width,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey200
                                                                  .value,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_delivery_package.svg",
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                controller
                                                                        .languageServices
                                                                        .language
                                                                        .value
                                                                        .package ??
                                                                    "-",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
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
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .comingSoon ??
                                                              "-",
                                                          style: controller
                                                              .typographyServices
                                                              .captionSmallBold
                                                              .value
                                                              .copyWith(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes
                                                      .INTRODUCTION_FOOD_SERVICE,
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      AspectRatio(
                                                        aspectRatio: 1 / 1,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                            context,
                                                          ).size.width,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey200
                                                                  .value,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_food.svg",
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                controller
                                                                        .languageServices
                                                                        .language
                                                                        .value
                                                                        .food ??
                                                                    "-",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
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
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .comingSoon ??
                                                              "-",
                                                          style: controller
                                                              .typographyServices
                                                              .captionSmallBold
                                                              .value
                                                              .copyWith(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey200
                                                  .value,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: Color(0XFFCFE9FC),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        "assets/icons/icon_wallet.svg",
                                                        width: 16,
                                                        height: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .myBalance ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .captionSmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey500
                                                                  .value,
                                                            ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          controller
                                                                  .userInfo
                                                                  .value
                                                                  .balance ??
                                                              0.0,
                                                        ),
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(
                                                          Routes
                                                              .DEPOSIT_BALANCE,
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        width: 46,
                                                        height: 36,
                                                        child: Column(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/icon_add_circle.svg",
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              controller
                                                                      .languageServices
                                                                      .language
                                                                      .value
                                                                      .topup ??
                                                                  "-",
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 14),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(
                                                          Routes
                                                              .HISTORY_BALANCE,
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        width: 46,
                                                        height: 36,
                                                        child: Column(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/icon_transaction_history.svg",
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              controller
                                                                      .languageServices
                                                                      .language
                                                                      .value
                                                                      .history ??
                                                                  "-",
                                                              style: controller
                                                                  .typographyServices
                                                                  .captionLargeRegular
                                                                  .value,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .promoToday ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(Routes.PROMOTION);
                                              },
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .seeAll ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      if (controller
                                          .availableCouponList
                                          .isEmpty) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 16),
                                              Text(
                                                "Belum Ada Promosi Tersedia",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeBold
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Tenang, promo menarik sedang kami siapkan. Stay tuned dan cek kembali ya!",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      if (controller
                                          .availableCouponList
                                          .isNotEmpty) ...[
                                        CarouselSlider(
                                          items: [
                                            for (var availableCoupon
                                                in controller
                                                    .availableCouponList) ...[
                                              Padding(
                                                padding:
                                                    controller
                                                            .availableCouponList
                                                            .indexOf(
                                                              availableCoupon,
                                                            ) ==
                                                        0
                                                    ? EdgeInsets.only(left: 16)
                                                    : controller
                                                              .availableCouponList
                                                              .indexOf(
                                                                availableCoupon,
                                                              ) ==
                                                          controller
                                                              .availableCouponList
                                                              .length
                                                    ? EdgeInsets.only(left: 12)
                                                    : EdgeInsets.only(
                                                        left: 12,
                                                        right: 16,
                                                      ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      Routes.VOUCHER_DETAIL,
                                                      arguments: {
                                                        "coupon_detail":
                                                            availableCoupon,
                                                      },
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Placeholder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                          options: CarouselOptions(
                                            onPageChanged: (index, reason) {
                                              controller.indexBanner.value =
                                                  index.toDouble();
                                            },
                                            height: 155,
                                            enableInfiniteScroll: false,
                                            autoPlay: false,
                                            disableCenter: true,
                                            viewportFraction: 0.85,
                                            aspectRatio: 311 / 155,
                                            padEnds: false,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: DotsIndicator(
                                            dotsCount:
                                                controller.bannerUrlList.length,
                                            position:
                                                controller.indexBanner.value,
                                            decorator: DotsDecorator(
                                              spacing: EdgeInsets.symmetric(
                                                horizontal: 3,
                                                vertical: 4,
                                              ),
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey300
                                                  .value,
                                              activeColor: controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 32),
                                    ],
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
            ],
            if (controller.indexNavigationBar.value == 1) ...[
              Expanded(child: ActivityView()),
            ],
            if (controller.indexNavigationBar.value == 2) ...[
              Expanded(child: AccountView()),
            ],
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            Divider(
              height: 0,
              color: controller.themeColorServices.neutralsColorGrey100.value,
              thickness: 2,
            ),
            NavigationBar(
              height: 64,
              backgroundColor:
                  controller.themeColorServices.neutralsColorGrey0.value,
              selectedIndex: controller.indexNavigationBar.value,
              onDestinationSelected: (value) {
                controller.indexNavigationBar.value = value;
              },
              destinations: [
                GestureDetector(
                  onTap: () {
                    controller.indexNavigationBar.value = 0;
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 28.5 / 2,
                          ),
                          child: Divider(
                            height: 0,
                            color: controller.indexNavigationBar.value == 0
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : Colors.transparent,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(height: 9),
                        SvgPicture.asset(
                          "assets/icons/icon_home.svg",
                          height: 24,
                          width: 24,
                          color: controller.indexNavigationBar.value == 0
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.languageServices.language.value.home ??
                              "-",
                          style: controller
                              .typographyServices
                              .captionLargeBold
                              .value
                              .copyWith(
                                color: controller.indexNavigationBar.value == 0
                                    ? controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value
                                    : controller
                                          .themeColorServices
                                          .neutralsColorGrey400
                                          .value,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.indexNavigationBar.value = 1;
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 28.5 / 2,
                            right: 28.5 / 2,
                          ),
                          child: Divider(
                            height: 0,
                            color: controller.indexNavigationBar.value == 1
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : Colors.transparent,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        SvgPicture.asset(
                          "assets/icons/icon_activity.svg",
                          height: 24,
                          width: 24,
                          color: controller.indexNavigationBar.value == 1
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.languageServices.language.value.activity ??
                              "-",
                          style: controller
                              .typographyServices
                              .captionLargeBold
                              .value
                              .copyWith(
                                color: controller.indexNavigationBar.value == 1
                                    ? controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value
                                    : controller
                                          .themeColorServices
                                          .neutralsColorGrey400
                                          .value,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.indexNavigationBar.value = 2;
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 28.5 / 2,
                            right: 24,
                          ),
                          child: Divider(
                            height: 0,
                            color: controller.indexNavigationBar.value == 2
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : Colors.transparent,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        SvgPicture.asset(
                          "assets/icons/icon_account.svg",
                          height: 24,
                          width: 24,
                          color: controller.indexNavigationBar.value == 2
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.languageServices.language.value.account ??
                              "-",
                          style: controller
                              .typographyServices
                              .captionLargeBold
                              .value
                              .copyWith(
                                color: controller.indexNavigationBar.value == 2
                                    ? controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value
                                    : controller
                                          .themeColorServices
                                          .neutralsColorGrey400
                                          .value,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
