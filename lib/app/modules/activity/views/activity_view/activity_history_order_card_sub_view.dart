import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/utils/order_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ActivityHistoryOrderCardSubView extends GetView<ActivityController> {
  final HistoryOrder historyOrder;
  const ActivityHistoryOrderCardSubView({
    super.key,
    required this.historyOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          if ([1, 2, 3, 4, 5, 6, 7].contains(historyOrder.state)) {
            try {
              var isCancelled = await isOrderHasBeenCancelled(
                orderId: historyOrder.orderId.toString(),
                orderType: historyOrder.orderType!,
              );

              if (isCancelled == true) {
                SnackbarHelper.showSnackbarError(
                  text:
                      controller
                          .languageServices
                          .language
                          .value
                          .orderHasBeenCancelled ??
                      "-",
                );
                await controller.refreshAll();
                return;
              }
            } on DioException catch (e) {
              SnackbarHelper.showSnackbarError(text: e.error.toString());
            } catch (e) {
              SnackbarHelper.showSnackbarError(text: e.toString());
            }
            await Get.toNamed(
              Routes.RIDE_ORDER_DETAIL,
              arguments: {
                "order_id": historyOrder.orderId.toString(),
                "order_type": historyOrder.orderType,
              },
            );
          } else {
            await Get.toNamed(
              Routes.ACTIVITY_DETAIL,
              arguments: {
                "order_id": historyOrder.orderId.toString(),
                "order_type": historyOrder.orderType,
              },
            );
          }

          await controller.refreshAll();
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(9.23),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_ride.svg",
                          width: 29.23,
                          height: 21.64,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
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
                                    ].contains(historyOrder.state)
                                    ? controller
                                          .themeColorServices
                                          .sematicColorBlue100
                                          .value
                                    : historyOrder.state == 10
                                    ? controller
                                          .themeColorServices
                                          .sematicColorRed100
                                          .value
                                    : !([
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                          ].contains(historyOrder.state)) &&
                                          !(historyOrder.state == 10) &&
                                          (historyOrder.orderScore ?? 0) == 0
                                    ? Color(0XFFFFFAE8)
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
                                      ].contains(historyOrder.state)
                                      ? controller
                                            .themeColorServices
                                            .sematicColorBlue300
                                            .value
                                      : historyOrder.state == 10
                                      ? controller
                                            .themeColorServices
                                            .sematicColorRed400
                                            .value
                                      : !([
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                              6,
                                              7,
                                            ].contains(historyOrder.state)) &&
                                            !(historyOrder.state == 10) &&
                                            (historyOrder.orderScore ?? 0) == 0
                                      ? Color(0XFFF7E9BC)
                                      : controller
                                            .themeColorServices
                                            .sematicColorGreen200
                                            .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
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
                                    ].contains(historyOrder.state)
                                    ? controller
                                              .languageServices
                                              .language
                                              .value
                                              .inProcess ??
                                          "-"
                                    : historyOrder.state == 10
                                    ? controller
                                              .languageServices
                                              .language
                                              .value
                                              .canceled ??
                                          "-"
                                    : !([
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                          ].contains(historyOrder.state)) &&
                                          !(historyOrder.state == 10) &&
                                          (historyOrder.orderScore ?? 0) == 0
                                    ? "Penilaian"
                                    : controller
                                              .languageServices
                                              .language
                                              .value
                                              .orderCompleted ??
                                          "-",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(
                                      color:
                                          [
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                          ].contains(historyOrder.state)
                                          ? controller
                                                .themeColorServices
                                                .sematicColorBlue500
                                                .value
                                          : historyOrder.state == 10
                                          ? controller
                                                .themeColorServices
                                                .sematicColorRed500
                                                .value
                                          : !([1, 2, 3, 4, 5, 6, 7].contains(
                                                  historyOrder.state,
                                                )) &&
                                                !(historyOrder.state == 10) &&
                                                (historyOrder.orderScore ??
                                                        0) ==
                                                    0
                                          ? Color(0XFFEAA82D)
                                          : controller
                                                .themeColorServices
                                                .sematicColorGreen500
                                                .value,
                                    ),
                              ),
                            ),
                            if ([
                              1,
                              2,
                              3,
                              4,
                              5,
                              6,
                              7,
                            ].contains(historyOrder.state))
                              ...[]
                            else ...[
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(
                                  historyOrder.state == 10
                                      ? 0
                                      : historyOrder.payMoney,
                                ),
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value,
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
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
                                  return SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_pinpoint_green.svg",
                                        width: 11,
                                        height: 14.14,
                                      ),
                                    ),
                                  );
                                }

                                return SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_pinpoint_red.svg",
                                      width: 11,
                                      height: 14.14,
                                    ),
                                  ),
                                );
                              },
                              contentsBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                  bottom: index != 1 ? 10 : 0,
                                  top: 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index == 0) ...[
                                      Text(
                                        historyOrder.startAddress ?? "-",
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    if (index == 1) ...[
                                      Text(
                                        historyOrder.endAddress ?? "-",
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              itemCount: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          historyOrder.orderTime == null
                              ? "-"
                              : DateFormat(
                                  'dd MMMM yyyy ⬩ HH:mm',
                                  controller
                                      .languageServices
                                      .languageCode
                                      .value,
                                ).format(
                                  DateTime.parse(
                                    historyOrder.orderTime!.replaceFirst(
                                      ' ',
                                      'T',
                                    ),
                                  ),
                                ),
                          style: controller
                              .typographyServices
                              .captionLargeRegular
                              .value,
                          selectionColor: controller
                              .themeColorServices
                              .neutralsColorGrey600
                              .value,
                        ),
                        if ([
                              1,
                              2,
                              3,
                              4,
                              5,
                              6,
                              7,
                            ].contains(historyOrder.state) ==
                            false) ...[
                          SizedBox(height: 8),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await controller.homeController.refreshAll(
                                    firstInit: true,
                                  );
                                  if (controller
                                      .homeController
                                      .isActiveOrderListNotEmpty
                                      .value) {
                                    SnackbarHelper.showSnackbarError(
                                      text:
                                          controller
                                              .languageServices
                                              .language
                                              .value
                                              .snackbarOrderNotSuccess ??
                                          "-",
                                    );
                                    return;
                                  }

                                  await Get.toNamed(
                                    Routes.CREATE_ORDER_RIDE,
                                    arguments: {
                                      "origin_address_name":
                                          historyOrder.startAddressName,
                                      "origin_address":
                                          historyOrder.startAddress,
                                      "origin_latitude": historyOrder.startLat
                                          .toString(),
                                      "origin_longitude": historyOrder.startLon
                                          .toString(),
                                      "destination_address_name":
                                          historyOrder.endAddressName,
                                      "destination_address":
                                          historyOrder.endAddress,
                                      "destination_latitude": historyOrder
                                          .endLat
                                          .toString(),
                                      "destination_longitude": historyOrder
                                          .endLon
                                          .toString(),
                                    },
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
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
                                      SizedBox(width: 2),
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 13,
                                            height: 7.5,
                                            colorFilter: ColorFilter.mode(
                                              controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!([
                                    1,
                                    2,
                                    3,
                                    4,
                                    5,
                                    6,
                                    7,
                                  ].contains(historyOrder.state)) &&
                                  !(historyOrder.state == 10) &&
                                  (historyOrder.orderScore ?? 0) == 0) ...[
                                SizedBox(width: 24),
                                Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .giveRating ??
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
                                      SizedBox(width: 2),
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 13,
                                            height: 7.5,
                                            colorFilter: ColorFilter.mode(
                                              controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
