import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RideOrderWaitingDriverPickUpPanelSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderWaitingDriverPickUpPanelSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 262,
      maxHeight: MediaQuery.of(context).size.height * 0.7561,
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
          color: controller.themeColorServices.overlayDark200.value.withValues(
            alpha: 0.3,
          ),
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
              color: Color(0XFFCEE2F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Driver segera tiba, menunggu: ${controller.getEstimatedTimeInMinutesInText()}",
                        style:
                            controller.typographyServices.bodySmallBold.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
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
                                  borderRadius: BorderRadius.circular(999),
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
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                      .orderRideDetail
                                                      .value
                                                      .licensePlate ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(fontSize: 18),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "${controller.orderRideDetail.value.brand} · ${controller.orderRideDetail.value.carColor}",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFF7D7D7D),
                                                  ),
                                            ),
                                            Text(
                                              "${controller.orderRideDetail.value.driverName}",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFF7D7D7D),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Stack(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Column(
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
                                              SizedBox(height: 16 + 4 + 2),
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                      Routes.RIDE_CALL_SENDBIRD,
                                      arguments: {
                                        'is_caller': true,
                                        'driver_id': controller
                                            .orderRideDetail
                                            .value
                                            .driverId,
                                        'driver_name': controller
                                            .orderRideDetail
                                            .value
                                            .driverName,
                                        'driver_avatar_url': controller
                                            .orderRideDetail
                                            .value
                                            .driverAvatar,
                                      },
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
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                child: LoaderElevatedButton(
                                  onPressed: () async {
                                    // Get.toNamed(
                                    //   Routes.RIDE_CHAT,
                                    // );

                                    Get.toNamed(
                                      Routes.RIDE_CHAT_SENDBIRD,
                                      arguments: {
                                        "driver_id": controller
                                            .orderRideDetail
                                            .value
                                            .driverId,
                                        "driver_name": controller
                                            .orderRideDetail
                                            .value
                                            .driverName,
                                        "driver_avatar_url": controller
                                            .orderRideDetail
                                            .value
                                            .driverAvatar,
                                        "order_id": controller
                                            .orderRideDetail
                                            .value
                                            .orderId,
                                        "order_type": controller
                                            .orderRideDetail
                                            .value
                                            .orderType,
                                        "state": controller
                                            .orderRideDetail
                                            .value
                                            .state,
                                        "driver_license_plate": controller
                                            .orderRideDetail
                                            .value
                                            .licensePlate,
                                      },
                                    );

                                    // await controller
                                    //     .sendbirdChatServices
                                    //     .searchChannelById(
                                    //       driverId: 184,
                                    //     );
                                  },
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
                                        .copyWith(color: Colors.white),
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
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
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    left: 8,
                                    right: 8,
                                    bottom: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                          overflow: TextOverflow.ellipsis,
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                          overflow: TextOverflow.ellipsis,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                if (controller.orderRideDetail.value.payType ==
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
                                          borderRadius: BorderRadius.circular(
                                            8,
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
                                if (controller.orderRideDetail.value.payType ==
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
                                          borderRadius: BorderRadius.circular(
                                            8,
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
                          padding: EdgeInsets.symmetric(horizontal: 16),
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
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorSlate100
                                        .value,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
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
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: 54,
                            width: MediaQuery.of(context).size.width,
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
                                    "order_type":
                                        controller.orderRideDetail.value.type,
                                  },
                                );
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
              ],
            ),
          ),
        );
      },
    );
  }
}
