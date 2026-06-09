import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';

class ActivityCardActionSubView extends GetView<ActivityController> {
  final HistoryOrder historyOrder;
  const ActivityCardActionSubView({super.key, required this.historyOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (OrderState.COMPLETED_STATE_LIST.contains(historyOrder.state)) ...[
          SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.onTapOrderAgain(historyOrder: historyOrder);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        controller.languageServices.language.value.orderAgain ??
                            "-",
                        style: controller.typographyServices.bodyLargeBold.value
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
                              controller.themeColorServices.primaryBlue.value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (historyOrder.state ==
                  OrderState.WAITING_RATING_EVALUATION) ...[
                SizedBox(width: 24),
                GestureDetector(
                  onTap: () async {
                    await controller.onTapActivity(historyOrder: historyOrder);
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
                                controller.themeColorServices.primaryBlue.value,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
