import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_action_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_origin_destination_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view.dart';

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
          await controller.onTapActivity(historyOrder: historyOrder);
          // Get.toNamed(
          //   Routes.ADVANCED_BOOKING_DETAIL,
          //   arguments: {
          //     "order_id": historyOrder.orderId.toString(),
          //     "order_type": historyOrder.orderType,
          //   },
          // );
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (historyOrder.reservation == 1) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .activityCategoryNormal ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFEA7405),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .activityCategoryBooking ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                    ),
                                  ),
                                ],
                                SizedBox(width: 8),
                                ActivityCardStatus(state: historyOrder.state),
                              ],
                            ),
                            Visibility(
                              visible: OrderState.COMPLETED_STATE_LIST.contains(
                                historyOrder.state,
                              ),
                              child: Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(
                                  historyOrder.state ==
                                          OrderState.ORDER_CANCELLED
                                      ? 0
                                      : historyOrder.payMoney,
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
                          startAddress: historyOrder.startAddress ?? "-",
                          endAddress: historyOrder.endAddress ?? "-",
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
                        ActivityCardActionSubView(historyOrder: historyOrder),
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
