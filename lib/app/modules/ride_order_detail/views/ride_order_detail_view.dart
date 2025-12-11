import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/ride_order_detail_controller.dart';

class RideOrderDetailView extends GetView<RideOrderDetailController> {
  const RideOrderDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition:
                                  controller.initialCameraPosition.value,
                              onMapCreated:
                                  (GoogleMapController googleMapController) {
                                    controller.googleMapController =
                                        googleMapController;
                                  },
                              markers: controller.markers,
                              polylines: controller.polylines,
                            ),
                            if (controller
                                    .isPinLocationWaitingForDriverHide
                                    .value ==
                                false) ...[
                              Center(
                                child: AvatarGlow(
                                  glowRadiusFactor: 2,
                                  glowColor: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  glowCount: 3,
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_pin_location_waiting_for_driver.svg",
                                    width: 32,
                                    height: 42,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height * (150 / 812),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
