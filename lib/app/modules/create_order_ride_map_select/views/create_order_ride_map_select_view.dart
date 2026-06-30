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
                          onLongPress: (position) {},
                          onTap: (position) {},
                          onCameraMoveStarted: () {
                            if (controller.isClosed) return;
                            if (controller.isRecommendationCameraMove.value) {
                              return;
                            }
                            controller.onUserCameraMoveStarted();
                          },
                          onCameraIdle: () {
                            if (controller.isClosed) return;
                            if (controller.isRecommendationCameraMove.value) {
                              controller.onProgrammaticCameraIdle();
                              return;
                            }

                            // Only fetch recommendations after the user pans the map.
                            if (controller.isMoveCameraFrom.value != "user") {
                              return;
                            }

                            controller.isUserMoveMapCamera.value = false;

                            final lat = controller.latitude.value;
                            final lng = controller.longitude.value;
                            if (lat == null || lng == null) return;

                            controller.updateLocationLatLng(
                              latitude: double.parse(lat),
                              longitude: double.parse(lng),
                            );
                          },
                          onCameraMove: (position) {
                            if (controller.isClosed) return;
                            if (controller.isFetch.value) return;
                            if (controller.isRecommendationCameraMove.value) {
                              return;
                            }
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
                                if (controller.isClosed) return;

                                if (controller.type.value == 'origin') {
                                  await controller.refreshMarkerDriverNearby();
                                  if (controller.isClosed) return;

                                  controller.enableDriverNearbyTimer();
                                }
                                if (!controller.isClosed) {
                                  controller.isFetch.value = false;
                                }
                              },
                        ),
                      ),
                      Center(
                        child: Transform.translate(
                          offset: const Offset(0, -20.4),
                          child: SvgPicture.asset(
                            controller.type.value == "origin"
                                ? "assets/icons/icon_recommendation_location_select_origin.svg"
                                : "assets/icons/icon_recommendation_location_select_destination.svg",
                            width: 31,
                            height: 50.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: controller.type.value == "origin"
                      ? MediaQuery.of(context).size.height * ((812 / 2) / 812)
                      : MediaQuery.of(context).size.height * ((812 / 2) / 812) -
                            100,
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
