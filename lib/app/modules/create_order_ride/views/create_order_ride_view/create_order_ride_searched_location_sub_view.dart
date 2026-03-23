import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';

class CreateOrderRideSearchedLocationSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideSearchedLocationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          if (controller.isOriginHasPrimaryFocus.value == true) ...[
            for (var location in controller.originGeocodingPlaceList) ...[
              GestureDetector(
                onTap: () async {
                  await controller.onTapOriginSearchedLocation(
                    selectedCurrentLocation: location,
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
                          if (location.customDistanceKm != null) ...[
                            SizedBox(height: 6),
                            Text(
                              "${location.customDistanceKm!.toStringAsFixed(2)}${controller.languageServices.language.value.km}",
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
                              location.name == "" || location.name == null
                                  ? "-"
                                  : location.name!,
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              location.address ?? "-",
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
          ] else ...[
            for (var location in controller.destinationGeocodingPlaceList) ...[
              GestureDetector(
                onTap: () async {
                  await controller.onTapDestinationSearchedLocation(
                    selectedCurrentLocation: location,
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
                          if (location.customDistanceKm != null) ...[
                            SizedBox(height: 6),
                            Text(
                              "${location.customDistanceKm!.toStringAsFixed(2)}km",
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
                              location.name == "" || location.name == null
                                  ? "-"
                                  : location.name!,
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              location.address ?? "-",
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
