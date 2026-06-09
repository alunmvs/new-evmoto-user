import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';

class ActivityDetailDriverInformationSubView
    extends GetView<ActivityDetailController> {
  const ActivityDetailDriverInformationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey300.value,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.orderRideDetail.value.licensePlate ?? "-",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${controller.orderRideDetail.value.brand} · ${controller.orderRideDetail.value.carColor}",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(color: Color(0XFF7D7D7D)),
                  ),
                  if (controller.orderRideDetail.value.state != 9) ...[
                    Text(
                      "${controller.orderRideDetail.value.driverName}",
                      style: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(color: Color(0XFF7D7D7D)),
                    ),
                  ],
                ],
              ),
            ),
            if (controller.orderRideDetail.value.state != 9) ...[
              SizedBox(width: 16),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      if (controller.orderRideDetail.value.driverAvatar !=
                          null) ...[
                        CircleAvatar(
                          radius: 48 / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            controller.orderRideDetail.value.driverAvatar!,
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 12,
                            width: 12,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_star.svg",
                                  width: 9.75,
                                  height: 9,
                                  colorFilter: ColorFilter.mode(
                                    controller
                                        .themeColorServices
                                        .sematicColorYellow400
                                        .value,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            (controller.orderRideDetail.value.score ?? 0.0)
                                .toStringAsPrecision(2),
                            style: controller
                                .typographyServices
                                .captionLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
