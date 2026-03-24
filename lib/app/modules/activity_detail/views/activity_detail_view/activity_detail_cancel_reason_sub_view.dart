import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';

class ActivityDetailCancelReasonSubView
    extends GetView<ActivityDetailController> {
  const ActivityDetailCancelReasonSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.themeColorServices.neutralsColorGrey200.value,
          width: 1,
        ),
      ),
      child: Text(
        controller.orderRideDetail.value.remark == null ||
                controller.orderRideDetail.value.remark == ""
            ? "-"
            : controller.orderRideDetail.value.remark!,
        style: controller.typographyServices.bodySmallBold.value,
      ),
    );
  }
}
