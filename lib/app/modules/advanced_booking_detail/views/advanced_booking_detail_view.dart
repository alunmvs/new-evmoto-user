import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view/advanced_booking_detail_invoice_sub_view.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view/advanced_booking_detail_map_origin_destination_information_sub_view.dart';
import 'package:new_evmoto_user/app/utils/general_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../controllers/advanced_booking_detail_controller.dart';

class AdvancedBookingDetailView
    extends GetView<AdvancedBookingDetailController> {
  const AdvancedBookingDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: controller.isCriticalError.value
              ? null
              : Text(
                  "Detail Jadwal Pemesanan",
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Completed
                  if ([2].contains(controller.advancedBooking.value.state) &&
                      controller.advancedBooking.value.spawnedOrderState ==
                          9) ...[
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatTravelTime(),
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    controller
                                            .orderRideDetail
                                            .value
                                            .licensePlate ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFF7D7D7D)),
                                  ),
                                  Text(
                                    "${controller.orderRideDetail.value.brand ?? '-'} · ${controller.orderRideDetail.value.carColor ?? '-'}",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFF7D7D7D)),
                                  ),
                                  Text(
                                    controller
                                            .orderRideDetail
                                            .value
                                            .driverName ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(color: Color(0XFF7D7D7D)),
                                  ),
                                ],
                              ),
                            ),
                            if (controller.advancedBooking.value.state !=
                                9) ...[
                              SizedBox(width: 16),
                              Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    children: [
                                      if (controller
                                              .orderRideDetail
                                              .value
                                              .driverAvatar !=
                                          null) ...[
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
                                      ],
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/icon_star.svg",
                                                  width: 9.75,
                                                  height: 9,
                                                  colorFilter: ColorFilter.mode(
                                                    controller
                                                        .themeColorServices
                                                        .sematicColorYellow400
                                                        .value,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            (controller
                                                        .orderRideDetail
                                                        .value
                                                        .score ??
                                                    0.0)
                                                .toStringAsPrecision(2),
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
                                        ],
                                      ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
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
                            controller.orderRideDetail.value.orderNum ?? "-",
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
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 340 / 180,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition:
                                controller.initialCameraPosition.value,
                            onMapCreated:
                                (
                                  GoogleMapController googleMapController,
                                ) async {
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
                            myLocationButtonEnabled: false,
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            indoorViewEnabled: false,
                            cameraTargetBounds: CameraTargetBounds(
                              LatLngBounds(
                                southwest: LatLng(-11.0, 95.0),
                                northeast: LatLng(6.5, 141.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
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
                                    width: 29,
                                    height: 29,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_pinpoint_green.svg",
                                        width: 19.94,
                                        height: 25.63,
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
                                  width: 29,
                                  height: 29,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_pinpoint_red.svg",
                                      width: 19.94,
                                      height: 25.63,
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
                                          _formatOrderTime(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .insertTime,
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

                                    if (controller
                                                .advancedBooking
                                                .value
                                                .startAddressName !=
                                            '' &&
                                        controller
                                                .advancedBooking
                                                .value
                                                .startAddressName !=
                                            null) ...[
                                      Text(
                                        controller
                                                .advancedBooking
                                                .value
                                                .startAddressName ??
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
                                    ] else ...[
                                      Text(
                                        controller
                                                .advancedBooking
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
                                          _formatOrderTime(
                                            controller
                                                .orderRideDetail
                                                .value
                                                .arriveTime,
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
                                          "${formatDoubleToString((controller.orderRideDetail.value.mileage ?? 0.0))} ${(controller.languageServices.language.value.km ?? 'km').toLowerCase()}",
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
                                    if (controller
                                                .advancedBooking
                                                .value
                                                .endAddressName !=
                                            '' &&
                                        controller
                                                .advancedBooking
                                                .value
                                                .endAddressName !=
                                            null) ...[
                                      Text(
                                        controller
                                                .advancedBooking
                                                .value
                                                .endAddressName ??
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
                                    ] else ...[
                                      Text(
                                        controller
                                                .advancedBooking
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.orderRideDetail.value.state !=
                                10) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .travelExpense ??
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
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(controller.getTravelFare()),
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
                              if ((controller
                                          .orderRideDetail
                                          .value
                                          .additionalCharge ??
                                      0) !=
                                  0) ...[
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .additionalCost ??
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
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(
                                        controller
                                                .orderRideDetail
                                                .value
                                                .additionalCharge ??
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
                              ],
                              if (controller.getPromoMoney() != 0) ...[
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .promotion ??
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
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: '-Rp',
                                        decimalDigits: 0,
                                      ).format(controller.getPromoMoney()),
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
                              ],
                              SizedBox(height: 12),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey700
                                            .value,
                                      ),
                                ),
                                if (controller.orderRideDetail.value.payType ==
                                    2) ...[
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_wallet.svg",
                                              fit: BoxFit.fitWidth,
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
                                                .evmotoBalance ??
                                            "-",
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
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_cash.svg",
                                              fit: BoxFit.fitWidth,
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
                            SizedBox(height: 12),
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
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey700
                                            .value,
                                      ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp',
                                    decimalDigits: 0,
                                  ).format(
                                    controller.orderRideDetail.value.state == 10
                                        ? 0
                                        : (controller
                                                  .orderRideDetail
                                                  .value
                                                  .payMoney ??
                                              0.0),
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
                          ],
                        ),
                      ),
                    ),
                    if (OrderState.WAITING_RATING_EVALUATION ==
                        controller.orderRideDetail.value.state) ...[
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      textAlign: TextAlign.center,
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
                                      textAlign: TextAlign.center,
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
                                              colorFilter: ColorFilter.mode(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorYellow400
                                                    .value,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onRatingUpdate: (rating) async {
                                        controller.rating.value = rating;
                                        await controller.getRatingLabelList(
                                          rating: rating.toInt(),
                                        );
                                      },
                                      glow: false,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  for (var ratingLabel
                                      in controller.ratingLabelList) ...[
                                    ChoiceChip(
                                      selected: ratingLabel.isSelected ?? false,
                                      onSelected: (value) {
                                        ratingLabel.isSelected = value;
                                        controller.ratingLabelList.refresh();
                                      },
                                      labelPadding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 12,
                                      ),
                                      showCheckmark: false,
                                      color: WidgetStatePropertyAll(
                                        ratingLabel.isSelected == true
                                            ? Color(0XFFEAF4FF)
                                            : controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                      ),
                                      side: BorderSide(
                                        color: ratingLabel.isSelected == true
                                            ? Color(0XFFC2D4E9)
                                            : Color(0XFFBFBFBF),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          9999,
                                        ),
                                      ),
                                      label: Text(
                                        ratingLabel.value ?? "-",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color:
                                                  ratingLabel.isSelected == true
                                                  ? controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value
                                                  : Color(0XFF272727),
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 12),
                              LoaderElevatedButton(
                                child: Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .submitReview ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () async {
                                  // await controller.onTapSubmitAndReview();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (controller.orderRideDetail.value.orderScore != null &&
                        controller.orderRideDetail.value.orderScore != 0) ...[
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey200
                                  .value,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              colorFilter: ColorFilter.mode(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorYellow400
                                                    .value,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          controller
                                              .orderRideDetail
                                              .value
                                              .orderScore
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
                              if (controller.ratingLabelList.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    for (var ratingLabel
                                        in controller.ratingLabelList) ...[
                                      ChoiceChip(
                                        selected: true,
                                        onSelected: (value) {},
                                        labelPadding: EdgeInsets.all(0),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        showCheckmark: false,
                                        color: WidgetStatePropertyAll(
                                          Color(0XFFEAF4FF),
                                        ),
                                        side: BorderSide(
                                          color: Color(0XFFC2D4E9),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                        ),
                                        label: Text(
                                          ratingLabel.value ?? "-",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
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
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
                  ]
                  // Others
                  else ...[
                    SizedBox(height: 8),
                    if ([
                      0,
                      1,
                    ].contains(controller.advancedBooking.value.state)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0XFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFFFFFFF),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32 / 2,
                                backgroundColor: Color(0XFFD9D9D9),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_calendar_schedule_fill.svg",
                                  width: 15.75,
                                  height: 15.75,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTravelTime(),
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusDescriptionScheduled ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if ([
                      2,
                    ].contains(controller.advancedBooking.value.state)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0XFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFFFFFFF),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32 / 2,
                                backgroundColor: Color(0XFFD9D9D9),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_calendar_schedule_fill.svg",
                                  width: 15.75,
                                  height: 15.75,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTravelTime(),
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusDescriptionInService ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if ([
                      5,
                    ].contains(controller.advancedBooking.value.state)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0XFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFFFFFFF),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32 / 2,
                                backgroundColor: Color(0XFFD9D9D9),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_advance_order_cancel.svg",
                                  width: 16.67,
                                  height: 16.67,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTravelTime(),
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller
                                                  .advancedBooking
                                                  .value
                                                  .actorType ==
                                              "user"
                                          ? (controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .advancedBookingStatusDescriptionCancelledUser ??
                                                "-")
                                          : (controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .advancedBookingStatusDescriptionCancelledDriver ??
                                                "-"),
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if ([
                      6,
                    ].contains(controller.advancedBooking.value.state)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0XFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFFFFFFF),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32 / 2,
                                backgroundColor: Color(0XFFD9D9D9),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_advance_order_expired.svg",
                                  width: 18.33,
                                  height: 13.33,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTravelTime(),
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusDescriptionExpired ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
                    Container(
                      height: 5.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey100
                            .value,
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child:
                          AdvancedBookingDetailMapOriginDestinationInformationSubView(),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AdvancedBookingDetailInvoiceSubView(),
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            if (controller.isFetch.value == true) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: controller.themeColorServices.neutralsColorGrey0.value,
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        bottomNavigationBar:
            controller.isFetch.value || controller.isCriticalError.value
            ? null
            : controller.isAbleCancelAdvanceBooking() == true
            ? BottomAppBar(
                height: 78,
                padding: EdgeInsets.all(16),
                color: controller.themeColorServices.neutralsColorGrey0.value,
                shadowColor: controller.themeColorServices.overlayDark100.value
                    .withValues(alpha: 0.1),
                child: Column(
                  children: [
                    SizedBox(
                      height: 46,
                      width: Get.width,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.transparent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await controller.onTapCancel();
                        },
                        child: Text(
                          controller.languageServices.language.value.cancel ??
                              "-",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .redColor
                                    .value,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : controller.isAbleOrderAgainAdvanceBooking() == true
            ? BottomAppBar(
                height: 78,
                padding: EdgeInsets.all(16),
                color: controller.themeColorServices.neutralsColorGrey0.value,
                shadowColor: controller.themeColorServices.overlayDark100.value
                    .withValues(alpha: 0.1),
                child: Column(
                  children: [
                    SizedBox(
                      height: 46,
                      width: Get.width,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await controller.onTapOrderAgain();
                        },
                        child: Text(
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
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  String _formatTravelTime() {
    final travelTime = controller.advancedBooking.value.travelTime;
    if (travelTime == null || travelTime.isEmpty) {
      return '-';
    }
    return DateFormat(
      'dd MMMM yyyy ⬩ HH:mm',
      controller.languageServices.languageCode.value,
    ).format(DateTime.parse(travelTime.replaceFirst(' ', 'T')));
  }

  String _formatOrderTime(String? time) {
    if (time == null || time.isEmpty) {
      return '-';
    }
    return DateFormat(
      'HH:mm',
      controller.languageServices.languageCode.value,
    ).format(DateTime.parse(time.replaceFirst(' ', 'T')));
  }
}
