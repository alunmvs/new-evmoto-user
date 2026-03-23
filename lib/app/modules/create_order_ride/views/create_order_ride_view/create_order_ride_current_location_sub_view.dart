import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';

class CreateOrderRideCurrentLocationSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideCurrentLocationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.locationServices.currentLatitude.value == null
          ? Container()
          : GestureDetector(
              onTap: () async {
                if (controller.isLatLngOriginFilled() == false) {
                  await controller.onTapOriginCurrentLocation();
                } else {
                  await controller.onTapDestinationCurrentLocation();
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_current_location.svg",
                            width: 14.33,
                            height: 14.33,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .currentLocation ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value,
                          ),
                          SizedBox(height: 4),
                          Text(
                            controller
                                    .recommendationCurrentLocationList
                                    .first
                                    .addressDetail ??
                                "-",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey500
                                      .value,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
