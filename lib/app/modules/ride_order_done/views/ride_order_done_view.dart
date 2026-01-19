import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../controllers/ride_order_done_controller.dart';

class RideOrderDoneView extends GetView<RideOrderDoneController> {
  const RideOrderDoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.orderCompleted ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
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
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color:
                    controller.themeColorServices.neutralsColorSlate100.value,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 15.5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 48 / 2,
                                    backgroundImage: CachedNetworkImageProvider(
                                      controller
                                          .orderRideDetail
                                          .value
                                          .driverAvatar!,
                                    ),
                                  ),
                                  // SvgPicture.asset(
                                  //   "assets/icons/icon_profile.svg",
                                  //   width: 48,
                                  //   height: 48,
                                  // ),
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
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey200
                                                    .value,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                        "assets/icons/icon_star.svg",
                                                        width: 13,
                                                        height: 12,
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorYellow400
                                                            .value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  controller
                                                      .orderRideDetail
                                                      .value
                                                      .score!
                                                      .toStringAsFixed(2),
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Container(
                                            padding: EdgeInsets.symmetric(
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
                                                  BorderRadius.circular(8),
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
                                                  .value,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: 33,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorSlate100
                                    .value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  controller.orderRideDetail.value.orderId
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
                      SizedBox(height: 8),
                      Container(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .howTravelExperience ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeBold
                                              .value,
                                        ),
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .scoreTravelExperience ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .bodyLargeBold
                                              .value,
                                        ),
                                        SizedBox(height: 8),
                                        RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          unratedColor: controller
                                              .themeColorServices
                                              .neutralsColorSlate100
                                              .value,
                                          itemBuilder: (context, _) => SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/icon_star.svg",
                                                  width: 39,
                                                  height: 36,
                                                  color: controller
                                                      .themeColorServices
                                                      .sematicColorYellow400
                                                      .value,
                                                ),
                                              ],
                                            ),
                                          ),
                                          onRatingUpdate: (rating) {
                                            controller.rating.value = rating;
                                          },
                                          glow: false,
                                        ),
                                      ],
                                    ),
                                  ],
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
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Timeline.tileBuilder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  builder: TimelineTileBuilder(
                                    contentsAlign: ContentsAlign.basic,
                                    nodePositionBuilder: (context, index) {
                                      return 0;
                                    },
                                    indicatorPositionBuilder: (context, index) {
                                      return 0;
                                    },
                                    startConnectorBuilder: (context, index) {
                                      if (index != 0) {
                                        return DashedLineConnector(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorSlate400
                                              .value,
                                        );
                                      }
                                      return null;
                                    },
                                    endConnectorBuilder: (context, index) {
                                      if (index != 1) {
                                        return DashedLineConnector(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorSlate400
                                              .value,
                                        );
                                      }
                                      return null;
                                    },
                                    indicatorBuilder: (context, index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.5,
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/icons/icon_origin.svg",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5.5,
                                        ),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_pinpoint.svg",
                                              width: 18,
                                              height: 21,
                                              color: controller
                                                  .themeColorServices
                                                  .sematicColorRed400
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    contentsBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(
                                        left: 4,
                                        right: 4,
                                        bottom: index != 1 ? 27 : 0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (index == 0) ...[
                                            Row(
                                              children: [
                                                Text(
                                                  "Penjemputan",
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
                                                ),
                                                Text(
                                                  " ⬩ ",
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
                                                ),
                                                Text(
                                                  controller
                                                          .orderRideDetail
                                                          .value
                                                          .travelTime ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
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
                                            SizedBox(height: 4),
                                            Text(
                                              controller
                                                      .orderRideDetail
                                                      .value
                                                      .startAddress ??
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
                                            ),
                                          ],
                                          if (index == 1) ...[
                                            Row(
                                              children: [
                                                Text(
                                                  "Tujuan",
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
                                                ),
                                                Text(
                                                  " ⬩ ",
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
                                                ),
                                                Text(
                                                  controller
                                                          .orderRideDetail
                                                          .value
                                                          .arriveTime ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .captionLargeRegular
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
                                            SizedBox(height: 4),
                                            Text(
                                              controller
                                                      .orderRideDetail
                                                      .value
                                                      .endAddress ??
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
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    itemCount: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                width: MediaQuery.of(context).size.width,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Metode Pembayaran",
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
                                                  BorderRadius.circular(8),
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
                                                  BorderRadius.circular(8),
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
                                            "Saldo EVMoto",
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
                            SizedBox(height: 12),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
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
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.startingPrice} (${controller.orderRideDetail.value.startMileage!.toStringAsPrecision(2)}) ${controller.languageServices.language.value.km}",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .startMoney,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.waitFee} (${controller.orderRideDetail.value.wait!.toStringAsPrecision(2)}) minutes",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .waitMoney,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.mileageFee} (${controller.orderRideDetail.value.mileage!.toStringAsPrecision(2)}) ${controller.languageServices.language.value.km}",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .mileageMoney,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.timeCost} (${controller.orderRideDetail.value.duration!.toStringAsPrecision(2)}) ${controller.languageServices.language.value.km}",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .durationMoney,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${controller.languageServices.language.value.longDistanceFee} (${controller.orderRideDetail.value.longDistance!.toStringAsPrecision(2)}) ${controller.languageServices.language.value.km}",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .longDistanceMoney,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .surcharge ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .additionalCharge,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .collectedByDrivers ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .payMoney,
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

                                // Column(
                                //   children: [

                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //           "Ongkos Perjalanan",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallRegular
                                //               .value,
                                //         ),
                                //         Text(
                                //           "Rp25.000",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallBold
                                //               .value,
                                //         ),
                                //       ],
                                //     ),
                                //     SizedBox(height: 12),
                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //           "Biaya Aplikasi",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallRegular
                                //               .value,
                                //         ),
                                //         Text(
                                //           "Rp5.000",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallBold
                                //               .value,
                                //         ),
                                //       ],
                                //     ),
                                //     SizedBox(height: 12),
                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //           "Voucher Aplikasi",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallRegular
                                //               .value,
                                //         ),
                                //         Text(
                                //           "-Rp10.000",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallBold
                                //               .value,
                                //         ),
                                //       ],
                                //     ),
                                //     SizedBox(height: 12),
                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text(
                                //           "Total",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallBold
                                //               .value,
                                //         ),
                                //         Text(
                                //           "Rp20.000",
                                //           style: controller
                                //               .typographyServices
                                //               .bodySmallBold
                                //               .value
                                //               .copyWith(
                                //                 color: controller
                                //                     .themeColorServices
                                //                     .primaryBlue
                                //                     .value,
                                //               ),
                                //         ),
                                //       ],
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: controller.themeColorServices.neutralsColorGrey0.value,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          child: Column(
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.onTapDone();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    controller.languageServices.language.value.finished ?? "-",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
