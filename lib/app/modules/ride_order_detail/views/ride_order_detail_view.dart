import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/ride_order_detail_controller.dart';

class RideOrderDetailView extends GetView<RideOrderDetailController> {
  const RideOrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition:
                                  controller.initialCameraPosition.value,
                              onMapCreated:
                                  (GoogleMapController googleMapController) {
                                    controller.googleMapController =
                                        googleMapController;
                                  },
                              markers: controller.markers,
                              polylines: controller.polylines,
                              tiltGesturesEnabled:
                                  controller
                                      .isPinLocationWaitingForDriverHide
                                      .value ==
                                  true,
                              zoomGesturesEnabled:
                                  controller
                                      .isPinLocationWaitingForDriverHide
                                      .value ==
                                  true,
                              rotateGesturesEnabled:
                                  controller
                                      .isPinLocationWaitingForDriverHide
                                      .value ==
                                  true,
                              scrollGesturesEnabled:
                                  controller
                                      .isPinLocationWaitingForDriverHide
                                      .value ==
                                  true,
                            ),
                            if (controller
                                    .isPinLocationWaitingForDriverHide
                                    .value ==
                                false) ...[
                              Center(
                                child: AvatarGlow(
                                  glowRadiusFactor: 2,
                                  glowColor: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  glowCount: 3,
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_pin_location_waiting_for_driver.svg",
                                    width: 32 - 10,
                                    height: 42 - 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height * (150 / 812),
                      ),
                    ],
                  ),
                  Container(
                    height: 96,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0XFFFFFFFF),
                          Color(0XFFFFFFFF).withValues(alpha: 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Container(
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey300
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: controller
                                            .themeColorServices
                                            .overlayDark200
                                            .value
                                            .withValues(alpha: 0.3),
                                        blurRadius: 32,
                                        spreadRadius: -6,
                                        offset: Offset(0, -1),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_back.svg",
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
                        ),
                      ],
                    ),
                  ),
                  if (controller.orderRideDetail.value.state == 1) ...[
                    SlidingUpPanel(
                      minHeight: 328 - 16,
                      maxHeight: 328 - 16,
                      padding: EdgeInsets.all(0),
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
                              .withValues(alpha: 0.3),
                          blurRadius: 32,
                          spreadRadius: -6,
                          offset: Offset(0, -1),
                        ),
                      ],
                      panel: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .evMotorcycleDriverSearch ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                                SizedBox(height: 16),
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(999),
                                  minHeight: 8,
                                  color: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  backgroundColor: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                              ],
                            ),
                          ),
                          DashedLine(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6),
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
                                              width: 17.31,
                                              height: 23.28,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "ECGO EV Moto",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey800
                                                  .value,
                                            ),
                                      ),
                                      Spacer(),
                                      SizedBox(width: 8),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_account.svg",
                                            width: 12,
                                            height: 12,
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey800
                                                .value,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "1 ${controller.languageServices.language.value.passenger}",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey800
                                                      .value,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      if (controller.payType.value == 2) ...[
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_wallet.svg",
                                                width: 12,
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 11),
                                        Text(
                                          "Saldo EVMOTO",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey800
                                                    .value,
                                              ),
                                        ),
                                      ],
                                      if (controller.payType.value == 3) ...[
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_cash.svg",
                                                width: 12,
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 11),
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .cash ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey800
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DashedLine(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 46,
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () async {
                                  await controller
                                      .onTapOrderRideCancelBeforeDriver();
                                },
                                style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                    controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value
                                        .withValues(alpha: 0.1),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Batalkan",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .sematicColorRed400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (controller.orderRideDetail.value.state == 2 ||
                      controller.orderRideDetail.value.state == 3) ...[
                    SlidingUpPanel(
                      minHeight: 262,
                      maxHeight: MediaQuery.of(context).size.height * 0.7561,
                      padding: EdgeInsets.all(0),
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
                              .withValues(alpha: 0.3),
                          blurRadius: 32,
                          spreadRadius: -6,
                          offset: Offset(0, -1),
                        ),
                      ],
                      panelBuilder: (sc) {
                        return Obx(
                          () => Container(
                            width: MediaQuery.of(context).size.width,
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
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0XFFF5F9FF),
                                        Color(0XFFCDE2F8),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 0.5],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_location_time.svg",
                                                    width: 19.89,
                                                    height: 24,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .languageServices
                                                        .language
                                                        .value
                                                        .driverArrivedIn ??
                                                    "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallBold
                                                    .value,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(
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
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                controller
                                                    .getEstimatedTimeInMinutesInText(),
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .sematicColorGreen500
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: sc,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 16),
                                                Container(
                                                  width: 33,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey300
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          999,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 14,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey300
                                                            .value,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 48 / 2,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                controller
                                                                    .orderRideDetail
                                                                    .value
                                                                    .driverAvatar!,
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
                                                                      .orderRideDetail
                                                                      .value
                                                                      .driverName ??
                                                                  "-",
                                                              style: controller
                                                                  .typographyServices
                                                                  .bodyLargeBold
                                                                  .value,
                                                            ),
                                                            SizedBox(height: 4),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                  decoration: BoxDecoration(
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
                                                                      SizedBox(
                                                                        height:
                                                                            16,
                                                                        width:
                                                                            16,
                                                                        child: Row(
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              "assets/icons/icon_star.svg",
                                                                              width: 13,
                                                                              height: 12,
                                                                              color: controller.themeColorServices.sematicColorYellow400.value,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        controller
                                                                            .orderRideDetail
                                                                            .value
                                                                            .score!
                                                                            .toStringAsPrecision(
                                                                              2,
                                                                            ),
                                                                        style: controller
                                                                            .typographyServices
                                                                            .bodySmallBold
                                                                            .value
                                                                            .copyWith(
                                                                              color: controller.themeColorServices.neutralsColorGrey700.value,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                  decoration: BoxDecoration(
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
                                                                            .orderRideDetail
                                                                            .value
                                                                            .licensePlate ??
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
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                DashedLine(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              bottom: 16,
                                              left: 16,
                                              right: 16,
                                              top: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 46,
                                                  child: OutlinedButton(
                                                    onPressed: () async {
                                                      Get.toNamed(
                                                        Routes.RIDE_CALL,
                                                      );
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      side: BorderSide(
                                                        color: controller
                                                            .themeColorServices
                                                            .primaryBlue
                                                            .value,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
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
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_phone.svg",
                                                                width: 11.18,
                                                                height: 12,
                                                                color: controller
                                                                    .themeColorServices
                                                                    .primaryBlue
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .telephone ??
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 46,
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.toNamed(
                                                          Routes.RIDE_CHAT,
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: controller
                                                            .themeColorServices
                                                            .primaryBlue
                                                            .value,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                                .languageServices
                                                                .language
                                                                .value
                                                                .chatDriver ??
                                                            "-",
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DashedLine(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 8,
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 4,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
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
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_origin.svg",
                                                                width: 13.33,
                                                                height: 13.33,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            controller
                                                                    .orderRideDetail
                                                                    .value
                                                                    .startAddress ??
                                                                "-",
                                                            style: controller
                                                                .typographyServices
                                                                .captionLargeBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .neutralsColorGrey700
                                                                      .value,
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
                                                  DashedLine(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey200
                                                        .value,
                                                    dashSpace: 2,
                                                    dashWidth: 2,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 4,
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 8,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
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
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_pinpoint.svg",
                                                                width: 12,
                                                                height: 14,
                                                                color: controller
                                                                    .themeColorServices
                                                                    .sematicColorRed400
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            controller
                                                                    .orderRideDetail
                                                                    .value
                                                                    .endAddress ??
                                                                "-",
                                                            style: controller
                                                                .typographyServices
                                                                .captionLargeBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .neutralsColorGrey700
                                                                      .value,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .paymentMethod ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value,
                                                  ),
                                                  SizedBox(height: 8),
                                                  if (controller
                                                          .orderRideDetail
                                                          .value
                                                          .payType ==
                                                      2) ...[
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorBlue100
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
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
                                                                "assets/icons/icon_wallet.svg",
                                                                width: 12,
                                                                height: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 11),
                                                        Text(
                                                          "Saldo EVMOTO",
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
                                                      ],
                                                    ),
                                                  ],
                                                  if (controller
                                                          .orderRideDetail
                                                          .value
                                                          .payType ==
                                                      3) ...[
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorBlue100
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
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
                                                                "assets/icons/icon_cash.svg",
                                                                width: 12,
                                                                height: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 11),
                                                        Text(
                                                          controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .cash ??
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
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(12),
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
                                                    BorderRadius.circular(12),
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .orderId ??
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
                                                  Container(
                                                    width: MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorSlate100
                                                          .value,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        controller
                                                            .orderRideDetail
                                                            .value
                                                            .orderId
                                                            .toString(),
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: SizedBox(
                                              height: 54,
                                              width: MediaQuery.of(
                                                context,
                                              ).size.width,
                                              child: TextButton(
                                                onPressed: () {
                                                  Get.toNamed(
                                                    Routes.RIDE_ORDER_CANCEL,
                                                    arguments: {
                                                      "order_id": controller
                                                          .orderRideDetail
                                                          .value
                                                          .orderId
                                                          .toString(),
                                                      "order_type": controller
                                                          .orderRideDetail
                                                          .value
                                                          .type,
                                                    },
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all(
                                                        controller
                                                            .themeColorServices
                                                            .sematicColorRed400
                                                            .value
                                                            .withValues(
                                                              alpha: 0.1,
                                                            ),
                                                      ),
                                                  shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .cancel ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .bodyLargeBold
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorRed500
                                                            .value,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  if (controller.orderRideDetail.value.state == 4 ||
                      controller.orderRideDetail.value.state == 5) ...[
                    SlidingUpPanel(
                      minHeight: 168 + 121,
                      maxHeight: 168 + 121,
                      padding: EdgeInsets.all(0),
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
                              .withValues(alpha: 0.3),
                          blurRadius: 32,
                          spreadRadius: -6,
                          offset: Offset(0, -1),
                        ),
                      ],
                      panel: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 61,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_send.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .yourEstimateToYourDestination ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                      Spacer(),
                                      SizedBox(width: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          controller
                                              .getEstimatedTimeInMinutesInText(),
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorGreen500
                                                    .value,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 45,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,

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
                                      children: [
                                        SizedBox(height: 16),
                                        Container(
                                          width: 33,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey300
                                                    .value,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 48 / 2,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                        controller
                                                            .orderRideDetail
                                                            .value
                                                            .driverAvatar!,
                                                      ),
                                                ),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .orderRideDetail
                                                              .value
                                                              .driverName ??
                                                          "-",
                                                      style: controller
                                                          .typographyServices
                                                          .bodyLargeBold
                                                          .value,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
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
                                                              SizedBox(
                                                                height: 16,
                                                                width: 16,
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      "assets/icons/icon_star.svg",
                                                                      width: 13,
                                                                      height:
                                                                          12,
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .sematicColorYellow400
                                                                          .value,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                controller
                                                                    .orderRideDetail
                                                                    .value
                                                                    .score!
                                                                    .toStringAsPrecision(
                                                                      2,
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
                                                        SizedBox(width: 4),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
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
                                                                    .orderRideDetail
                                                                    .value
                                                                    .licensePlate ??
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
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        DashedLine(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey300
                                              .value,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DashedLine(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Metode Pembayaran ${controller.orderRideDetail.value.payType}",
                                            style: controller
                                                .typographyServices
                                                .bodySmallBold
                                                .value,
                                          ),
                                          SizedBox(height: 8),
                                          if (controller
                                                  .orderRideDetail
                                                  .value
                                                  .payType ==
                                              3) ...[
                                            Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue100
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                                        "assets/icons/icon_cash.svg",
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 11),
                                                Text(
                                                  "Cash",
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
                                              ],
                                            ),
                                          ],
                                          if (controller
                                                  .orderRideDetail
                                                  .value
                                                  .payType ==
                                              2) ...[
                                            Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue100
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                                        "assets/icons/icon_wallet.svg",
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 11),
                                                Text(
                                                  "Saldo EVMOTO",
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
                                              ],
                                            ),
                                          ],
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
                ],
              ),
      ),
    );
  }
}
