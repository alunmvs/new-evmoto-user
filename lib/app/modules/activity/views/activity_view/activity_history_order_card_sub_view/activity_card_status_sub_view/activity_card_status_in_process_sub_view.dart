import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';

class ActivityCardStatusInProcessSubView extends GetView<ActivityController> {
  const ActivityCardStatusInProcessSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: controller.themeColorServices.sematicColorBlue100.value,
        border: Border.all(
          color: controller.themeColorServices.sematicColorBlue300.value,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        controller.languageServices.language.value.inProcess ?? "-",
        style: controller.typographyServices.captionLargeRegular.value.copyWith(
          color: controller.themeColorServices.sematicColorBlue500.value,
        ),
      ),
    );
  }
}
