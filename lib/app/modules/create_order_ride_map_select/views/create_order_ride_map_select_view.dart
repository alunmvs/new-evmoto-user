import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/views/create_order_ride_map_select_view/map_select_footer_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/views/create_order_ride_map_select_view/map_select_header_sub_view.dart';

import '../controllers/create_order_ride_map_select_controller.dart';

class CreateOrderRideMapSelectView
    extends GetView<CreateOrderRideMapSelectController> {
  const CreateOrderRideMapSelectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Animarker(
                        mapId: controller.googleMapController.future.then<int>(
                          (value) => value.mapId,
                        ),
                        markers: Set<Marker>.from(controller.markers.values),
                        duration: const Duration(milliseconds: 2400),
                        curve: Curves.linear,
                        shouldAnimateCamera: false,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          indoorViewEnabled: false,
                          onLongPress: (position) {
                            print("oke-long-press");
                          },
                          onTap: (position) {
                            print("oke-tap");
                          },
                          onCameraMoveStarted: () {
                            // cancel the recommendation location list timer)
                            controller.isUserMoveMapCamera.value = true;
                            controller.isMoveCameraFrom.value = "user";
                          },
                          onCameraIdle: () {
                            if (controller.isRecommendationCameraMove.value) {
                              controller.isRecommendationCameraMove.value = false;
                              controller.isUserMoveMapCamera.value = false;
                              controller.isMoveCameraFrom.value = "system";
                              return;
                            }

                            if (controller.isMoveCameraFrom.value == "user") {
                              controller.isUserMoveMapCamera.value = false;
                            }

                            controller.updateLocationLatLng(
                              latitude: double.parse(
                                controller.latitude.value!,
                              ),
                              longitude: double.parse(
                                controller.longitude.value!,
                              ),
                            );
                          },
                          onCameraMove: (position) async {
                            if (controller.isFetch.value == true) return;
                            controller.latitude.value = position.target.latitude
                                .toString();
                            controller.longitude.value = position
                                .target
                                .longitude
                                .toString();
                          },
                          initialCameraPosition:
                              controller.initialCameraPosition.value,
                          onMapCreated:
                              (GoogleMapController googleMapController) async {
                                controller.googleMapController.complete(
                                  googleMapController,
                                );
                                controller.isFetch.value = true;
                                await controller.fillForm();
                                await controller.refreshMarkerDriverNearby();
                                controller.enableDriverNearbyTimer();
                                controller.isFetch.value = false;
                              },
                        ),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          controller.type.value == "origin"
                              ? "assets/icons/icon_pinpoint_map_green.svg"
                              : "assets/icons/icon_pinpoint_map_red.svg",
                          width: 22.69,
                          height: 29.17,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (150 / 812),
                ),
              ],
            ),
            MapSelectFooterSubView(),
            if (controller.isFetch.value == true) ...[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                ),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                ),
              ),
            ],
            MapSelectHeaderSubView(),
          ],
        ),
      ),
    );
  }
}
