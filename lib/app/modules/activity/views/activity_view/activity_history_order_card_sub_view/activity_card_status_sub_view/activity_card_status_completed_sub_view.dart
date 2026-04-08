import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';

class ActivityCardStatusCompletedSubView extends GetView<ActivityController> {
  const ActivityCardStatusCompletedSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: controller.themeColorServices.sematicColorGreen100.value,
        border: Border.all(
          color: controller.themeColorServices.sematicColorGreen200.value,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        controller.languageServices.language.value.orderCompleted ?? "-",
        style: controller.typographyServices.captionLargeRegular.value.copyWith(
          color: controller.themeColorServices.sematicColorGreen500.value,
        ),
      ),
    );
  }
}
