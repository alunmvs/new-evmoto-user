import 'package:flutter/material.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_advanced_booking_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_cancelled_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_completed_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_in_process_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_rating_evaluation_sub_view.dart';

class ActivityCardStatus extends StatelessWidget {
  final int? state;
  const ActivityCardStatus({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (OrderState.CANCELLED_STATE_LIST.contains(state)) ...[
          ActivityCardStatusCancelledSubView(),
        ] else if (state == OrderState.WAITING_RATING_EVALUATION) ...[
          ActivityCardStatusRatingEvaluationSubView(),
        ] else if (OrderState.ACTIVE_STATE_LIST.contains(state)) ...[
          ActivityCardStatusInProcessSubView(),
        ] else if (OrderState.COMPLETED_STATE_LIST.contains(state)) ...[
          ActivityCardStatusCompletedSubView(),
        ] else if (state == null) ...[
          ActivityCardStatusAdvancedBookingSubView(),
        ],
      ],
    );
  }
}
