import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';

class ActivityCardStatusAdvancedBookingSubView
    extends GetView<ActivityController> {
  const ActivityCardStatusAdvancedBookingSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0XFFFFF6E8),
        border: Border.all(color: Color(0XFFEA7405)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        controller.languageServices.language.value.orderScheduled ?? "-",
        style: controller.typographyServices.captionLargeRegular.value.copyWith(
          color: Color(0XFFEA7405),
        ),
      ),
    );
  }
}
