import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_origin_destination_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/advanced_booking_history_card/advanced_booking_action_sub_view.dart';

class AdvancedBookingHistoryCardSubView extends GetView<ActivityController> {
  final AdvancedBooking advancedOrder;
  const AdvancedBookingHistoryCardSubView({
    super.key,
    required this.advancedOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          await controller.onTapActivityAdvancedBooking(
            advancedBooking: advancedOrder,
          );
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
                            if ([0, 1].contains(advancedOrder.state)) ...[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFFFF6E8),
                                      border: Border.all(
                                        color: Color(0XFFEA7405),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusOrderScheduled ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFEA7405)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if ([2].contains(advancedOrder.state)) ...[
                              if (advancedOrder.spawnedOrderState == 9) ...[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0XFFCAEDDB),
                                        border: Border.all(
                                          color: Color(0XFF99CEB3),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .advancedBookingStatusOrderDone ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(color: Color(0XFF17412C)),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0XFFE3F1FF),
                                        border: Border.all(
                                          color: Color(0XFF0573EA),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        controller
                                                .languageServices
                                                .language
                                                .value
                                                .advancedBookingStatusOrderInService ??
                                            "-",
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(color: Color(0XFF0573EA)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                            if ([5].contains(advancedOrder.state)) ...[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFFFECEC),
                                      border: Border.all(
                                        color: Color(0XFFD9463E),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusOrderCancelled ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFD9463E)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if ([6].contains(advancedOrder.state)) ...[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFF6F6F6),
                                      border: Border.all(
                                        color: Color(0XFFB3B3B3),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .advancedBookingStatusOrderExpired ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            Visibility(
                              visible:
                                  advancedOrder.spawnedOrderState == null ||
                                  OrderState.COMPLETED_STATE_LIST.contains(
                                    advancedOrder.spawnedOrderState,
                                  ),
                              child: Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(
                                  advancedOrder.state ==
                                          OrderState.ORDER_CANCELLED
                                      ? 0
                                      : advancedOrder.spawnedOrderState == null
                                      ? advancedOrder.orderMoney
                                      : OrderState.COMPLETED_STATE_LIST
                                            .contains(
                                              advancedOrder.spawnedOrderState,
                                            )
                                      ? (advancedOrder.payMoney ?? 0)
                                      : (advancedOrder.payMoney ?? 0),
                                ),
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ActivityCardOriginDestinationSubView(
                          endAddress: advancedOrder.endAddress ?? "-",
                          startAddress: advancedOrder.startAddress ?? "-",
                        ),
                        SizedBox(height: 8),
                        Text(
                          advancedOrder.travelTime == null
                              ? "-"
                              : DateFormat(
                                  'dd MMMM yyyy ⬩ HH:mm',
                                  controller
                                      .languageServices
                                      .languageCode
                                      .value,
                                ).format(
                                  DateTime.parse(
                                    advancedOrder.travelTime!.replaceFirst(
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
                        AdvancedBookingActionSubView(
                          advancedBooking: advancedOrder,
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
