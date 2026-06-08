import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';

class ActivityDetailCancelDriverInformationSubView
    extends GetView<ActivityDetailController> {
  const ActivityDetailCancelDriverInformationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.orderRideDetail.value.licensePlate == "" ||
              controller.orderRideDetail.value.licensePlate == null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      controller.themeColorServices.neutralsColorGrey300.value,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/icon_profile.svg",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .cancelByPassenger ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(color: Color(0XFFB3B3B3)),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      controller.themeColorServices.neutralsColorGrey300.value,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/icon_profile.svg",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.orderRideDetail.value.actorType == "driver"
                              ? (controller
                                        .languageServices
                                        .language
                                        .value
                                        .cancelByDriver ??
                                    "-")
                              : (controller
                                        .languageServices
                                        .language
                                        .value
                                        .cancelByPassenger ??
                                    "-"),
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(color: Color(0XFFB3B3B3)),
                        ),
                        Text(
                          controller.orderRideDetail.value.driverName ?? "-",
                          style: controller
                              .typographyServices
                              .bodyLargeRegular
                              .value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
