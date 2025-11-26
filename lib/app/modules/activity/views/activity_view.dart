import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});
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
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
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
                    dividerColor: controller
                        .themeColorServices
                        .neutralsColorGrey200
                        .value,

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
                      Column(
                        children: [
                          if (controller.latestActivityList.isEmpty) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
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
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Column(
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
                          if (controller.historyActivityList.isEmpty) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
        ],
      ),
    );
  }
}
