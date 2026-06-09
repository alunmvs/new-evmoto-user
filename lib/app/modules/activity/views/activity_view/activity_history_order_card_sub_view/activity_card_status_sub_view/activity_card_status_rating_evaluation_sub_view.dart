import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';

class ActivityCardStatusRatingEvaluationSubView
    extends GetView<ActivityController> {
  const ActivityCardStatusRatingEvaluationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0XFFFFFAE8),
        border: Border.all(color: Color(0XFFF7E9BC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        controller.languageServices.language.value.rating ?? "-",
        style: controller.typographyServices.captionLargeRegular.value.copyWith(
          color: Color(0XFFEAA82D),
        ),
      ),
    );
  }
}
