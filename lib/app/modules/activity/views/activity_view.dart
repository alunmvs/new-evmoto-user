import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

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

                onTap: (value) {
                  controller.indexTabBar.value = value;
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
                            "Terkini",
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
                            "Riwayat",
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
                      RefreshIndicator(
                        color: controller.themeColorServices.primaryBlue.value,
                        backgroundColor: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        onRefresh: () async {},
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
                              if (controller.activeOrderList.isEmpty) ...[
                                SizedBox(height: 134),
                                SvgPicture.asset(
                                  "assets/images/img_latest_activity_not_found.svg",
                                  height: 120,
                                  width: 120,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Kamu sudah mencoba EV Moto?",
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
                                SizedBox(
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorBlue200
                                              .value,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Pesan EV Moto",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                              if (controller.activeOrderList.isNotEmpty) ...[
                                for (var latestActivity
                                    in controller.latestActivityList) ...[
                                  Container(
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (controller.latestActivityList
                                                    .indexOf(latestActivity) !=
                                                (controller
                                                        .latestActivityList
                                                        .length -
                                                    1)) ...[
                                              Text(
                                                "Jalan Haji Jian ke Plaza Pondok Gede",
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
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "08 February 2025 ⬩ 12:54",
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
                                            if (controller.latestActivityList
                                                    .indexOf(latestActivity) ==
                                                (controller
                                                        .latestActivityList
                                                        .length -
                                                    1)) ...[
                                              Text(
                                                "Jalan Hankam ke Pondok Indah Permai",
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
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_alert.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorRed500
                                                        .value,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Perjalanan Dibatalkan",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .sematicColorRed500
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                        Spacer(),
                                        SizedBox(width: 12),
                                        Text(
                                          "Rp56.000",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                                    "Lihat Riwayat Topup",
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
                          Divider(
                            height: 0,
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 16),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey700
                                            .value,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Antar",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Paket",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Makanan",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
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
                            child: RefreshIndicator(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              backgroundColor: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              onRefresh: () async {},
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              "Belum Ada Aktivitas Riwayat",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Lakukan aktivitas pertama dan lihat catatannya di sini!",
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
                                          onTap: () {
                                            Get.toNamed(Routes.ACTIVITY_DETAIL);
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
                                                  padding: EdgeInsets.symmetric(
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
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            .sematicColorGreen100
                                                            .value,
                                                        border: Border.all(
                                                          color: controller
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
                                                        "Order Selesai",
                                                        style: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .sematicColorGreen500
                                                                  .value,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      historyOrder.endAddress ??
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
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "08 February 2025 ⬩ 12:54",
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
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Order Lagi",
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
                                                        SizedBox(width: 2),
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
                                                ),
                                                Spacer(),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Rp25.000",
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
