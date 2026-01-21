import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: TabBar(
                controller: controller.tabController,
                padding: EdgeInsets.all(0),
                indicator: null,
                indicatorColor: Colors.transparent,
                dividerColor:
                    controller.themeColorServices.neutralsColorGrey200.value,
                onTap: (value) async {
                  controller.indexTabBar.value = value;

                  if (controller.indexTabBar.value == 0) {
                    await controller.getActiveOrderList();
                  } else {
                    await controller.getHistoryOrderList();
                  }
                },
                tabs: [
                  Tab(
                    height: 65,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: controller.indexTabBar.value == 0
                              ? LinearGradient(
                                  colors: [
                                    Color(0XFF0060C6),
                                    Color(0XFF004084),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                )
                              : null,
                          border: controller.indexTabBar.value == 0
                              ? Border.all(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                  width: 2,
                                )
                              : null,
                          borderRadius: controller.indexTabBar.value == 0
                              ? BorderRadius.circular(12)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            controller.languageServices.language.value.latest ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value
                                .copyWith(
                                  color: controller.indexTabBar.value == 0
                                      ? controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value
                                      : controller
                                            .themeColorServices
                                            .neutralsColorGrey700
                                            .value,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    height: 65,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: controller.indexTabBar.value == 1
                              ? LinearGradient(
                                  colors: [
                                    Color(0XFF0060C6),
                                    Color(0XFF004084),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                )
                              : null,
                          border: controller.indexTabBar.value == 1
                              ? Border.all(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                  width: 2,
                                )
                              : null,
                          borderRadius: controller.indexTabBar.value == 1
                              ? BorderRadius.circular(12)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .history ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value
                                .copyWith(
                                  color: controller.indexTabBar.value == 1
                                      ? controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value
                                      : controller
                                            .themeColorServices
                                            .neutralsColorGrey700
                                            .value,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller.latestActivityList.isEmpty
                              ? null
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                          gradient: controller.latestActivityList.isEmpty
                              ? LinearGradient(
                                  colors: [
                                    Color(0XFFFFFFFF),
                                    Color(0XFFCDE2F8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                )
                              : null,
                        ),
                      ),
                      SmartRefresher(
                        controller: controller.activeOrderRefreshController,
                        onRefresh: () async {
                          await controller.getActiveOrderList();
                          controller.activeOrderRefreshController
                              .refreshCompleted();
                        },
                        header: MaterialClassicHeader(
                          color:
                              controller.themeColorServices.primaryBlue.value,
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
                        // enablePullUp: controller.activeOrderSeeMore.value,
                        // onLoading: () async {
                        //   await controller.seeMoreActiveOrderList();
                        //   controller.activeOrderRefreshController
                        //       .loadComplete();
                        // },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              if (controller.isFetch.value) ...[
                                SizedBox(height: 134),
                                Center(
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                    ),
                                  ),
                                ),
                              ],
                              if (controller.isFetch.value == false) ...[
                                if (controller.activeOrderList.isEmpty) ...[
                                  SizedBox(height: 134),
                                  SvgPicture.asset(
                                    "assets/images/img_latest_activity_not_found.svg",
                                    height: 120,
                                    width: 120,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Kamu sudah mencoba EVMoto?",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Kamu bisa berpergian dengan nyaman, aman dan tentunya gak nambahin polusi di jakarta dong!",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  LoaderElevatedButton(
                                    isWidthFitToContent: true,
                                    onPressed: () async {
                                      await controller.homeController
                                          .onTapRideService();

                                      await controller.refreshAll();
                                    },
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    borderSide: BorderSide(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue200
                                          .value,
                                      width: 2,
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .orderEvMoto ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                                if (controller.activeOrderList.isNotEmpty) ...[
                                  for (var activeOrder
                                      in controller.activeOrderList) ...[
                                    GestureDetector(
                                      onTap: () async {
                                        await Get.toNamed(
                                          Routes.RIDE_ORDER_DETAIL,
                                          arguments: {
                                            "order_id": activeOrder.orderId
                                                .toString(),
                                            "order_type": activeOrder.orderType,
                                          },
                                        );
                                        await controller.refreshAll();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 24,
                                          bottom: 16,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.31,
                                                vertical: 7.34,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0XFFF5F9FF),
                                                    Color(0XFFCDE2F8),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: [0.0, 1.0],
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/icons/icon_ride.svg",
                                                width: 23.28,
                                                height: 17.31,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    activeOrder
                                                            .orderRide
                                                            ?.endAddress ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey700
                                                              .value,
                                                        ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    activeOrder
                                                            .orderRide
                                                            ?.travelTime ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey600
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'id_ID',
                                                symbol: 'Rp',
                                                decimalDigits: 0,
                                              ).format(
                                                activeOrder
                                                                .orderRide
                                                                ?.collectionFees !=
                                                            null &&
                                                        activeOrder
                                                                .orderRide
                                                                ?.collectionFees !=
                                                            0
                                                    ? activeOrder
                                                          .orderRide
                                                          ?.collectionFees
                                                    : activeOrder
                                                              .orderRide
                                                              ?.orderMoney ??
                                                          0.0,
                                              ),
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallBold
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DashedLine(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                  ],
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller.historyActivityList.isEmpty
                              ? null
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                          gradient: controller.historyActivityList.isEmpty
                              ? LinearGradient(
                                  colors: [
                                    Color(0XFFFFFFFF),
                                    Color(0XFFCDE2F8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                )
                              : null,
                        ),
                      ),
                      if (controller.isFetch.value == true) ...[
                        SizedBox(height: 134),
                        Center(
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                          ),
                        ),
                      ],
                      if (controller.isFetch.value == false) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await Get.toNamed(Routes.HISTORY_BALANCE);
                                await controller.refreshAll();
                              },
                              child: Container(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey300
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_wallet.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .viewTopupHistory ??
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
                                      Spacer(),
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 6,
                                            height: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey300
                                  .value,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () async {
                                        controller
                                                .historyOrderSelectedOrderType
                                                .value =
                                            1;
                                        await controller.getHistoryOrderList();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  1
                                              ? Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey700
                                                      .value,
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey400
                                                      .value,
                                                  width: 1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .delivery ??
                                              "-",
                                          style:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  1
                                              ? controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                              : controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        controller
                                                .historyOrderSelectedOrderType
                                                .value =
                                            2;
                                        await controller.getHistoryOrderList();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  2
                                              ? Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey700
                                                      .value,
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey400
                                                      .value,
                                                  width: 1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .package ??
                                              "-",
                                          style:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  2
                                              ? controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                              : controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        controller
                                                .historyOrderSelectedOrderType
                                                .value =
                                            3;
                                        await controller.getHistoryOrderList();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  3
                                              ? Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey700
                                                      .value,
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey400
                                                      .value,
                                                  width: 1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .food ??
                                              "-",
                                          style:
                                              controller
                                                      .historyOrderSelectedOrderType
                                                      .value ==
                                                  3
                                              ? controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value
                                              : controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey300
                                  .value,
                            ),
                            Expanded(
                              child: SmartRefresher(
                                controller:
                                    controller.historyOrderRefreshController,
                                onRefresh: () async {
                                  await controller.getHistoryOrderList();
                                  controller.historyOrderRefreshController
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
                                enablePullUp:
                                    controller.historyOrderSeeMore.value,
                                onLoading: () async {
                                  await controller.seeMoreHistoryOrderList();
                                  controller.historyOrderRefreshController
                                      .loadComplete();
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (controller
                                          .historyOrderList
                                          .isEmpty) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 134),
                                              SvgPicture.asset(
                                                "assets/images/img_history_activity_not_found.svg",
                                                height: 80,
                                                width: 80,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .activityNotFoundTitle ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeBold
                                                    .value,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .activityNotFoundDescription ??
                                                    "-",
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
                                          .historyOrderList
                                          .isNotEmpty) ...[
                                        for (var historyOrder
                                            in controller.historyOrderList) ...[
                                          GestureDetector(
                                            onTap: () async {
                                              if ([
                                                1,
                                                2,
                                                3,
                                                4,
                                                5,
                                                6,
                                                7,
                                              ].contains(historyOrder.state)) {
                                                await Get.toNamed(
                                                  Routes.RIDE_ORDER_DETAIL,
                                                  arguments: {
                                                    "order_id": historyOrder
                                                        .orderId
                                                        .toString(),
                                                    "order_type":
                                                        historyOrder.orderType,
                                                  },
                                                );
                                              } else {
                                                await Get.toNamed(
                                                  Routes.ACTIVITY_DETAIL,
                                                  arguments: {
                                                    "order_id": historyOrder
                                                        .orderId
                                                        .toString(),
                                                    "order_type":
                                                        historyOrder.orderType,
                                                  },
                                                );
                                              }

                                              await controller.refreshAll();
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 4.31,
                                                          vertical: 7.34,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0XFFF5F9FF),
                                                          Color(0XFFCDE2F8),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        stops: [0.0, 1.0],
                                                      ),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/icons/icon_ride.svg",
                                                      width: 23.28,
                                                      height: 17.31,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
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
                                                            color:
                                                                [
                                                                  1,
                                                                  2,
                                                                  3,
                                                                  4,
                                                                  5,
                                                                  6,
                                                                  7,
                                                                ].contains(
                                                                  historyOrder
                                                                      .state,
                                                                )
                                                                ? controller
                                                                      .themeColorServices
                                                                      .sematicColorBlue100
                                                                      .value
                                                                : historyOrder
                                                                          .state ==
                                                                      10
                                                                ? controller
                                                                      .themeColorServices
                                                                      .sematicColorRed100
                                                                      .value
                                                                : controller
                                                                      .themeColorServices
                                                                      .sematicColorGreen100
                                                                      .value,
                                                            border: Border.all(
                                                              color:
                                                                  [
                                                                    1,
                                                                    2,
                                                                    3,
                                                                    4,
                                                                    5,
                                                                    6,
                                                                    7,
                                                                  ].contains(
                                                                    historyOrder
                                                                        .state,
                                                                  )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .sematicColorBlue300
                                                                        .value
                                                                  : historyOrder
                                                                            .state ==
                                                                        10
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .sematicColorRed400
                                                                        .value
                                                                  : controller
                                                                        .themeColorServices
                                                                        .sematicColorGreen200
                                                                        .value,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            [
                                                                  1,
                                                                  2,
                                                                  3,
                                                                  4,
                                                                  5,
                                                                  6,
                                                                  7,
                                                                ].contains(
                                                                  historyOrder
                                                                      .state,
                                                                )
                                                                ? controller
                                                                          .languageServices
                                                                          .language
                                                                          .value
                                                                          .inProcess ??
                                                                      "-"
                                                                : historyOrder
                                                                          .state ==
                                                                      10
                                                                ? controller
                                                                          .languageServices
                                                                          .language
                                                                          .value
                                                                          .canceled ??
                                                                      "-"
                                                                : controller
                                                                          .languageServices
                                                                          .language
                                                                          .value
                                                                          .orderCompleted ??
                                                                      "-",
                                                            style: controller.typographyServices.captionLargeRegular.value.copyWith(
                                                              color:
                                                                  [
                                                                    1,
                                                                    2,
                                                                    3,
                                                                    4,
                                                                    5,
                                                                    6,
                                                                    7,
                                                                  ].contains(
                                                                    historyOrder
                                                                        .state,
                                                                  )
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .sematicColorBlue500
                                                                        .value
                                                                  : historyOrder
                                                                            .state ==
                                                                        10
                                                                  ? controller
                                                                        .themeColorServices
                                                                        .sematicColorRed500
                                                                        .value
                                                                  : controller
                                                                        .themeColorServices
                                                                        .sematicColorGreen500
                                                                        .value,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          historyOrder
                                                                  .endAddress ??
                                                              "-",
                                                          style: controller
                                                              .typographyServices
                                                              .bodySmallBold
                                                              .value
                                                              .copyWith(
                                                                color: controller
                                                                    .themeColorServices
                                                                    .neutralsColorGrey700
                                                                    .value,
                                                              ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          historyOrder
                                                                  .orderTime ??
                                                              "-",
                                                          style: controller
                                                              .typographyServices
                                                              .captionLargeRegular
                                                              .value
                                                              .copyWith(
                                                                color: controller
                                                                    .themeColorServices
                                                                    .neutralsColorGrey600
                                                                    .value,
                                                              ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        if ([
                                                              1,
                                                              2,
                                                              3,
                                                              4,
                                                              5,
                                                              6,
                                                              7,
                                                            ].contains(
                                                              historyOrder
                                                                  .state,
                                                            ) ==
                                                            false) ...[
                                                          Row(
                                                            children: [
                                                              Text(
                                                                controller
                                                                        .languageServices
                                                                        .language
                                                                        .value
                                                                        .orderAgain ??
                                                                    "-",
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
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              SizedBox(
                                                                width: 24,
                                                                height: 24,
                                                                child: Center(
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/icon_arrow_right.svg",
                                                                    width: 13,
                                                                    height: 7.5,
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
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'id_ID',
                                                      symbol: 'Rp',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      historyOrder
                                                                      .orderRide
                                                                      ?.collectionFees !=
                                                                  null &&
                                                              historyOrder
                                                                      .orderRide
                                                                      ?.collectionFees !=
                                                                  0
                                                          ? historyOrder
                                                                .orderRide
                                                                ?.collectionFees
                                                          : historyOrder
                                                                    .orderRide
                                                                    ?.orderMoney ??
                                                                0.0,
                                                    ),
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey700
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          DashedLine(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey200
                                                .value,
                                          ),
                                        ],
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
