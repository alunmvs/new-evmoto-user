import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_advertisement_list_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_bookmark_location_subview.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (Platform.isAndroid) {
            var now = DateTime.now();

            if (now.difference(controller.lastPressedBackDateTime.value) >
                Duration(seconds: 2)) {
              controller.lastPressedBackDateTime.value = now;

              var snackBar = SnackBar(
                behavior: SnackBarBehavior.fixed,
                backgroundColor:
                    controller.themeColorServices.primaryBlue.value,
                content: Text(
                  "Tekan sekali lagi untuk keluar aplikasi",
                  style: controller.typographyServices.bodySmallRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              );
              rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
            } else {
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
          appBar: controller.isFetch.value
              ? null
              : AppBar(
                  title: Column(
                    children: [
                      if (controller.indexNavigationBar.value == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.showRequiredAccessPermission();
                                    },
                                    child: Text(
                                      'Hello, mau kemana hari ini?',
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    controller.userInfo.value.name ?? "-",
                                    style: controller
                                        .typographyServices
                                        .headingSmallBold
                                        .value
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Get.toNamed(Routes.SENDBIRD_CHAT_LIST);
                                await controller.refreshAll();
                              },
                              child: Badge(
                                isLabelVisible:
                                    controller.totalUnreadMessageCount.value >
                                    0,
                                label: Text(
                                  controller.totalUnreadMessageCount.value > 99
                                      ? "99+"
                                      : controller.totalUnreadMessageCount.value
                                            .toString(),
                                  style: controller
                                      .typographyServices
                                      .captionSmallRegular
                                      .value,
                                ),
                                backgroundColor: Color(0XFF17CC8C),
                                child: SizedBox(
                                  width: 26.73,
                                  height: 26.73,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/icon_chat.svg',
                                        width: 23.34,
                                        height: 23.34,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  controller.totalUnreadMessageCount.value > 0
                                  ? 8
                                  : 0,
                            ),
                          ],
                        ),
                      ],
                      if (controller.indexNavigationBar.value == 1) ...[
                        Text(
                          controller.languageServices.language.value.activity ??
                              "-",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
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
                          controller.languageServices.language.value.account ??
                              "-",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
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
                  backgroundColor:
                      controller.themeColorServices.primaryBlue.value,
                  toolbarHeight: controller.indexNavigationBar.value == 0
                      ? 80
                      : null,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
          backgroundColor: controller.indexNavigationBar.value == 0
              ? controller.themeColorServices.neutralsColorGrey0.value
              : controller.themeColorServices.primaryBlue.value,
          extendBodyBehindAppBar: controller.indexNavigationBar.value == 0
              ? true
              : false,
          body: controller.isFetch.value
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (controller.indexNavigationBar.value == 0) ...[
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 65),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width /
                                      (375 / 369),
                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 375 / 369,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          onCameraMove: (position) async {
                                            await controller.getCurrentAddress(
                                              latitude:
                                                  position.target.latitude,
                                              longitude:
                                                  position.target.longitude,
                                            );
                                          },
                                          zoomControlsEnabled: false,
                                          initialCameraPosition: controller
                                              .initialCameraPosition
                                              .value,
                                          onMapCreated:
                                              (
                                                GoogleMapController
                                                googleMapController,
                                              ) async {
                                                controller.googleMapController =
                                                    googleMapController;
                                              },
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          width: 64 + 84 + 64,
                                          height: 38 + 84 + 38,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 84,
                                                  height: 84,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          9999,
                                                        ),
                                                    color: Color(
                                                      0XFF10ff34,
                                                    ).withValues(alpha: 0.15),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_pinpoint_green.svg",
                                                        width: 22.67,
                                                        height: 22.67,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await controller
                                                        .onTapRideService(
                                                          isFillCurrentLocation:
                                                              true,
                                                        );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      6,
                                                                    ),
                                                                topRight:
                                                                    Radius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: Text(
                                                          'Titik penjemputan',
                                                          style: controller
                                                              .typographyServices
                                                              .captionLargeRegular
                                                              .value
                                                              .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth: 200,
                                                            ),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 5,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            0xffffffff,
                                                          ),
                                                          borderRadius: BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                  6,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  6,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (controller
                                                                        .currentAddressIsLoading
                                                                        .value ==
                                                                    true ||
                                                                controller
                                                                        .isFetch
                                                                        .value ==
                                                                    true) ...[
                                                              Shimmer.fromColors(
                                                                baseColor: Colors
                                                                    .grey
                                                                    .shade300,
                                                                highlightColor:
                                                                    Colors
                                                                        .white,
                                                                child: Container(
                                                                  height: 18,
                                                                  width: 150,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ] else ...[
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                          maxWidth:
                                                                              175 -
                                                                              11,
                                                                        ),
                                                                    child: Text(
                                                                      controller
                                                                              .currentGeocodingAddress
                                                                              .value
                                                                              .name ??
                                                                          "-",
                                                                      style: controller
                                                                          .typographyServices
                                                                          .captionLargeRegular
                                                                          .value
                                                                          .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 16,
                                                                    height: 16,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/icon_arrow_right.svg",
                                                                          width:
                                                                              4.76,
                                                                          height:
                                                                              8.65,
                                                                          color: Color(
                                                                            0XFF272727,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ],
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
                                ),
                              ],
                            ),
                            SlidingUpPanel(
                              padding: EdgeInsets.all(0),
                              minHeight:
                                  MediaQuery.of(context).size.height -
                                  (65 +
                                      MediaQuery.of(context).size.width /
                                          (375 / 369)),
                              maxHeight: MediaQuery.of(context).size.height,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              color: Colors.transparent,
                              boxShadow: null,
                              panelBuilder: (sc) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //     horizontal: 16,
                                    //   ),
                                    //   child: Row(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.end,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: [
                                    //       GestureDetector(
                                    //         onTap: () async {
                                    //           await controller
                                    //               .moveGoogleMapCameraToCurrentLocation();
                                    //         },
                                    //         child: Container(
                                    //           width: 41,
                                    //           height: 41,
                                    //           decoration: BoxDecoration(
                                    //             color: Colors.white,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(
                                    //                   99999999,
                                    //                 ),
                                    //             boxShadow: [
                                    //               BoxShadow(
                                    //                 color: controller
                                    //                     .themeColorServices
                                    //                     .overlayDark200
                                    //                     .value
                                    //                     .withValues(
                                    //                       alpha: 0.12,
                                    //                     ),
                                    //                 blurRadius: 16,
                                    //                 spreadRadius: 2,
                                    //                 offset: Offset(0, -1),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //           child: Row(
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.center,
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.center,
                                    //             children: [
                                    //               SvgPicture.asset(
                                    //                 "assets/icons/icon_current_location.svg",
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 16),
                                    Expanded(
                                      child: SmartRefresher(
                                        controller:
                                            controller.homeRefreshController,
                                        onRefresh: () async {
                                          await controller.refreshAll();
                                          await controller.requestLocation();
                                          controller.homeRefreshController
                                              .refreshCompleted();
                                        },
                                        header: MaterialClassicHeader(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                        footer: ClassicFooter(
                                          loadStyle: LoadStyle.HideAlways,
                                          textStyle: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                          canLoadingIcon: null,
                                          loadingIcon: null,
                                          idleIcon: null,
                                          noMoreIcon: null,
                                          failedIcon: null,
                                        ),
                                        enablePullDown: true,
                                        child: Container(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          decoration: BoxDecoration(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey0
                                                      .value,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: controller
                                                          .themeColorServices
                                                          .overlayDark200
                                                          .value
                                                          .withValues(
                                                            alpha: 0.05,
                                                          ),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
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
                                                      child: Showcase.withWidget(
                                                        targetPadding:
                                                            EdgeInsets.all(16),
                                                        disableBarrierInteraction:
                                                            true,
                                                        key: controller
                                                            .destinationGlobalKey,
                                                        onTargetClick: () {},
                                                        disposeOnTap: false,
                                                        targetBorderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        targetShapeBorder:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                        container: Stack(
                                                          children: [
                                                            Positioned(
                                                              left: 0,
                                                              right: 0,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Transform.rotate(
                                                                    angle:
                                                                        45 *
                                                                        3.1415926535 /
                                                                        180,
                                                                    child: Container(
                                                                      width: 16,
                                                                      height:
                                                                          16,
                                                                      decoration: BoxDecoration(
                                                                        color: controller
                                                                            .themeColorServices
                                                                            .neutralsColorGrey0
                                                                            .value,
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(
                                                                                4,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        16,
                                                                      ),
                                                                  width: MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                                  decoration: BoxDecoration(
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .neutralsColorGrey0
                                                                        .value,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Text(
                                                                        controller.languageServices.language.value.coachmarkTitle1 ??
                                                                            "-",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodyLargeBold
                                                                            .value
                                                                            .copyWith(),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                        controller.languageServices.language.value.coachmarkDescription1 ??
                                                                            "-",
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodySmallRegular
                                                                            .value
                                                                            .copyWith(),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "1/5",
                                                                            style: controller.typographyServices.captionLargeBold.value.copyWith(
                                                                              color: controller.themeColorServices.neutralsColorGrey500.value,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                30,
                                                                            child: ElevatedButton(
                                                                              onPressed: () {
                                                                                ShowcaseView.get().next();
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: controller.themeColorServices.primaryBlue.value,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    8,
                                                                                  ),
                                                                                ),
                                                                                padding: EdgeInsets.symmetric(
                                                                                  horizontal: 16,
                                                                                  vertical: 0,
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  controller.languageServices.language.value.buttonNext1 ??
                                                                                      "-",
                                                                                  style: controller.typographyServices.bodySmallBold.value.copyWith(
                                                                                    color: controller.themeColorServices.neutralsColorGrey0.value,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await controller
                                                                .onTapRideService(
                                                                  isFillCurrentLocation:
                                                                      true,
                                                                );
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
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
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_pinpoint_red.svg",
                                                                  width: 18,
                                                                  height: 21,
                                                                ),
                                                                SizedBox(
                                                                  width: 11,
                                                                ),
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
                                                                        .value
                                                                        .copyWith(
                                                                          color: Color(
                                                                            0XFF9D9D9D,
                                                                          ),
                                                                        ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    HomeBookmarkLocationSubview(),
                                                    SizedBox(height: 16),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              HomeAdvertisementListSubView(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Visibility(
                                visible:
                                    controller.activeOrderStatus.value != '-',
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.onTapRideService(
                                      isFillCurrentLocation: false,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0XFFF8FBFE),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: controller
                                                .themeColorServices
                                                .overlayDark200
                                                .value
                                                .withValues(alpha: 0.25),
                                            blurRadius: 16,
                                            spreadRadius: 0,
                                            offset: Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0XFFF5F9FF),
                                                      Color(0XFFCDE2F8),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    stops: [0.0, 1.0],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        9.23,
                                                      ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_ride.svg",
                                                      width: 23.38,
                                                      height: 17.31,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Text(
                                                  controller
                                                      .activeOrderStatus
                                                      .value,
                                                  style: controller
                                                      .typographyServices
                                                      .bodyLargeBold
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .primaryBlue
                                                            .value,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icons/icon_arrow_right.svg",
                                                    width: 13 * 1.3,
                                                    height: 7.5 * 1.3,
                                                    color: controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
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
          bottomNavigationBar: controller.isFetch.value
              ? null
              : Stack(
                  children: [
                    Divider(
                      height: 0,
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey100
                          .value,
                      thickness: 2,
                    ),
                    NavigationBar(
                      height: 64,
                      backgroundColor: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      selectedIndex: controller.indexNavigationBar.value,
                      onDestinationSelected: (value) {
                        controller.indexNavigationBar.value = value;
                      },
                      destinations: [
                        GestureDetector(
                          onTap: () async {
                            controller.indexNavigationBar.value = 0;
                            await controller.refreshAll();
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
                                    color:
                                        controller.indexNavigationBar.value == 0
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
                                  color:
                                      controller.indexNavigationBar.value == 0
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .home ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .captionLargeBold
                                      .value
                                      .copyWith(
                                        color:
                                            controller
                                                    .indexNavigationBar
                                                    .value ==
                                                0
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
                          onTap: () async {
                            controller.indexNavigationBar.value = 1;

                            await controller.refreshAll();
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
                                    color:
                                        controller.indexNavigationBar.value == 1
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
                                  color:
                                      controller.indexNavigationBar.value == 1
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .activity ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .captionLargeBold
                                      .value
                                      .copyWith(
                                        color:
                                            controller
                                                    .indexNavigationBar
                                                    .value ==
                                                1
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
                          onTap: () async {
                            controller.indexNavigationBar.value = 2;
                            await controller.refreshAll();
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
                                    color:
                                        controller.indexNavigationBar.value == 2
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
                                  color:
                                      controller.indexNavigationBar.value == 2
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .account ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .captionLargeBold
                                      .value
                                      .copyWith(
                                        color:
                                            controller
                                                    .indexNavigationBar
                                                    .value ==
                                                2
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
      ),
    );
  }
}
