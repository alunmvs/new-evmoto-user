import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/ride_call_controller.dart';

class RideCallView extends GetView<RideCallController> {
  const RideCallView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Menelepon...",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        body: Stack(
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
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 56),
                    if (controller.status.value == "connected") ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey100
                              .value,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "01:54",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey800
                                    .value,
                              ),
                        ),
                      ),
                      SizedBox(height: 46),
                    ],
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_profile.svg",
                            width: 128,
                            height: 128,
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Franky Fransisco Marlissa",
                            style: controller
                                .typographyServices
                                .headingSmallBold
                                .value,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "EV Moto Driver",
                            style: controller
                                .typographyServices
                                .bodyLargeRegular
                                .value,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  if (controller.status.value == "calling") ...[
                    SizedBox(
                      height: 208,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .sematicColorRed400
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_call_decline.svg",
                                  width: 32,
                                  height: 32,
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .sematicColorGreen400
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_call_accept.svg",
                                  width: 32,
                                  height: 32,
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  if (controller.status.value == "connected") ...[
                    SizedBox(
                      height: 298,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller
                                          .themeColorServices
                                          .overlayDark100
                                          .value
                                          .withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(0, 3.33),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_microphone_on.svg",
                                      width: 24,
                                      height: 24,
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey700
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 40),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller
                                          .themeColorServices
                                          .overlayDark100
                                          .value
                                          .withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(0, 3.33),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_sound_on.svg",
                                      width: 24,
                                      height: 24,
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey700
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed400
                                    .value,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_call_decline.svg",
                                    width: 32,
                                    height: 32,
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
