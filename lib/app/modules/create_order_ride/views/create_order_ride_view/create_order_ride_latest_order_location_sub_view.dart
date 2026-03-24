import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';

class CreateOrderRideLatestOrderLocationSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideLatestOrderLocationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              controller.languageServices.language.value.lastLocation ?? "-",
              style: controller.typographyServices.bodySmallBold.value.copyWith(
                color: Color(0XFF7D7D7D),
              ),
            ),
          ),
          if (controller.isOriginHasPrimaryFocus.value == true) ...[
            for (var latestLocation
                in controller.recommendationOriginLocationList) ...[
              GestureDetector(
                onTap: () async {
                  await controller.onTapOriginLatestOrderLocation(
                    selectedCurrentLocation: latestLocation,
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: 14,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                                  "assets/icons/icon_pinpoint_primary_blue.svg",
                                  width: 11,
                                  height: 14.14,
                                ),
                              ],
                            ),
                          ),
                          if (latestLocation.customDistanceKm != null) ...[
                            SizedBox(height: 6),
                            Text(
                              "${latestLocation.customDistanceKm!.toStringAsFixed(2)}${controller.languageServices.language.value.km}",
                              style: controller
                                  .typographyServices
                                  .captionSmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latestLocation.name == "" ||
                                      latestLocation.name == null
                                  ? "-"
                                  : latestLocation.name!,
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              latestLocation.addressDetail ?? "-",
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
              Divider(
                height: 0,
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
            ],
          ],
          if (controller.isDestinationHasPrimaryFocus.value == true) ...[
            for (var latestLocation
                in controller.recommendationDestinationLocationList) ...[
              GestureDetector(
                onTap: () async {
                  await controller.onTapDestinationLatestOrderLocation(
                    selectedCurrentLocation: latestLocation,
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: 14,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                                  "assets/icons/icon_pinpoint_primary_blue.svg",
                                  width: 11,
                                  height: 14.14,
                                ),
                              ],
                            ),
                          ),
                          if (latestLocation.customDistanceKm != null) ...[
                            SizedBox(height: 6),
                            Text(
                              "${latestLocation.customDistanceKm!.toStringAsFixed(2)}${controller.languageServices.language.value.km}",
                              style: controller
                                  .typographyServices
                                  .captionSmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey500
                                        .value,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latestLocation.name == "" ||
                                      latestLocation.name == null
                                  ? "-"
                                  : latestLocation.name!,
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              latestLocation.addressDetail ?? "-",
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
              Divider(
                height: 0,
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
