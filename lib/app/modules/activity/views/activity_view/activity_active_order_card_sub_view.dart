import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ActivityActiveOrderCardSubView extends GetView<ActivityController> {
  final ActiveOrder activeOrder;
  const ActivityActiveOrderCardSubView({super.key, required this.activeOrder});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          await Get.toNamed(
            Routes.RIDE_ORDER_DETAIL,
            arguments: {
              "order_id": activeOrder.orderId.toString(),
              "order_type": activeOrder.orderType,
            },
          );
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
                                ].contains(activeOrder.state)
                                ? controller
                                      .themeColorServices
                                      .sematicColorBlue100
                                      .value
                                : activeOrder.state == 10
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
                                  ].contains(activeOrder.state)
                                  ? controller
                                        .themeColorServices
                                        .sematicColorBlue300
                                        .value
                                  : activeOrder.state == 10
                                  ? controller
                                        .themeColorServices
                                        .sematicColorRed400
                                        .value
                                  : controller
                                        .themeColorServices
                                        .sematicColorGreen200
                                        .value,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            [1, 2, 3, 4, 5, 6, 7].contains(activeOrder.state)
                                ? controller
                                          .languageServices
                                          .language
                                          .value
                                          .inProcess ??
                                      "-"
                                : activeOrder.state == 10
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
                                      ].contains(activeOrder.state)
                                      ? controller
                                            .themeColorServices
                                            .sematicColorBlue500
                                            .value
                                      : activeOrder.state == 10
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
                                        "assets/icons/icon_origin.svg",
                                        width: 13.33,
                                        height: 13.33,
                                      ),
                                    ),
                                  );
                                }

                                return SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_pinpoint.svg",
                                      width: 12,
                                      height: 14,
                                      colorFilter: ColorFilter.mode(
                                        controller
                                            .themeColorServices
                                            .sematicColorRed400
                                            .value,
                                        BlendMode.srcIn,
                                      ),
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
                                        activeOrder.startAddress ?? "-",
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
                                        activeOrder.endAddress ?? "-",
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
                          DateFormat(
                            'dd MMMM yyyy ⬩ HH:mm',
                            controller.languageServices.languageCode.value,
                          ).format(
                            DateTime.parse(
                              activeOrder.travelTime!.replaceFirst(' ', 'T'),
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
