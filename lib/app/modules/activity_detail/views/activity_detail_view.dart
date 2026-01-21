import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../controllers/activity_detail_controller.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.isFetch.value
                ? ""
                : DateFormat(
                    'dd MMMM yyyy ⬩ HH:mm',
                    controller.languageServices.languageCode.value,
                  ).format(
                    DateTime.parse(
                      controller.orderRideDetail.value.insertTime!.replaceFirst(
                        ' ',
                        'T',
                      ),
                    ),
                  ),
            selectionColor:
                controller.themeColorServices.neutralsColorGrey600.value,

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
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Container(
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32 / 2,
                              backgroundImage: CachedNetworkImageProvider(
                                controller.orderRideDetail.value.driverAvatar!,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              controller.orderRideDetail.value.driverName ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorSlate100
                              .value,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            controller.orderRideDetail.value.orderId.toString(),
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 343 / 223.98,
                          child: GoogleMap(
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
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomControlsEnabled: false,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                          ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0) ...[
                                    Row(
                                      children: [
                                        Text(
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .pickup ??
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
                                                      .insertTime ==
                                                  ""
                                              ? "-"
                                              : DateFormat(
                                                  'HH:mm',
                                                  controller
                                                      .languageServices
                                                      .languageCode
                                                      .value,
                                                ).format(
                                                  DateTime.parse(
                                                    controller
                                                        .orderRideDetail
                                                        .value
                                                        .insertTime!
                                                        .replaceFirst(' ', 'T'),
                                                  ),
                                                ),
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
                                          controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .objective ??
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
                                                      .arriveTime ==
                                                  ""
                                              ? "-"
                                              : DateFormat(
                                                  'HH:mm',
                                                  controller
                                                      .languageServices
                                                      .languageCode
                                                      .value,
                                                ).format(
                                                  DateTime.parse(
                                                    controller
                                                        .orderRideDetail
                                                        .value
                                                        .arriveTime!
                                                        .replaceFirst(' ', 'T'),
                                                  ),
                                                ),
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
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Metode Pembayaran",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                if (controller.orderRideDetail.value.payType ==
                                    2) ...[
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
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
                                      SizedBox(width: 2),
                                      Text(
                                        "Saldo EVMoto",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ],
                                  ),
                                ],
                                if (controller.orderRideDetail.value.payType ==
                                    3) ...[
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
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
                                      SizedBox(width: 2),
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .cash ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .total ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(
                                    controller.orderRideDetail.value.payMoney,
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
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .rating ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_star.svg",
                                        width: 13,
                                        height: 12,
                                        color: controller
                                            .themeColorServices
                                            .sematicColorYellow400
                                            .value,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    controller.orderRideDetail.value.orderScore
                                        .toString(),
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          padding: EdgeInsets.all(16),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          child: Column(
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapOrderAgain();
                },
                child: Text(
                  controller.languageServices.language.value.orderAgain ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
