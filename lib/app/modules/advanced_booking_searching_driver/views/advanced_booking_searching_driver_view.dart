import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_searching_driver/views/advanced_booking_searching_driver/advanced_booking_waiting_driver_acceptance_panel_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

import '../controllers/advanced_booking_searching_driver_controller.dart';

class AdvancedBookingSearchingDriverView
    extends GetView<AdvancedBookingSearchingDriverController> {
  const AdvancedBookingSearchingDriverView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Stack(
          clipBehavior: Clip.none,
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
                          initialCameraPosition:
                              controller.initialCameraPosition.value,
                          onMapCreated:
                              (GoogleMapController googleMapController) {
                                controller.googleMapController.complete(
                                  googleMapController,
                                );
                              },
                          polylines: controller.polylines,
                          tiltGesturesEnabled:
                              controller
                                  .isPinLocationWaitingForDriverHide
                                  .value ==
                              true,
                          zoomGesturesEnabled:
                              controller
                                  .isPinLocationWaitingForDriverHide
                                  .value ==
                              true,
                          rotateGesturesEnabled:
                              controller
                                  .isPinLocationWaitingForDriverHide
                                  .value ==
                              true,
                          scrollGesturesEnabled:
                              controller
                                  .isPinLocationWaitingForDriverHide
                                  .value ==
                              true,
                          cameraTargetBounds: CameraTargetBounds(
                            LatLngBounds(
                              southwest: LatLng(-11.0, 95.0),
                              northeast: LatLng(6.5, 141.0),
                            ),
                          ),
                        ),
                      ),
                      if (controller.isPinLocationWaitingForDriverHide.value ==
                          false) ...[
                        Center(
                          child: AvatarGlow(
                            glowRadiusFactor: 2,
                            glowColor: Color(0XFF01AC63),
                            glowCount: 3,
                            child: SvgPicture.asset(
                              "assets/icons/icon_pinpoint_map_green.svg",
                              width: 38,
                              height: 44.91,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFFFFFFFF),
                    Color(0XFFFFFFFF).withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: controller
                                      .themeColorServices
                                      .overlayDark200
                                      .value
                                      .withValues(alpha: 0.3),
                                  blurRadius: 32,
                                  spreadRadius: -6,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_back.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: controller
                                      .themeColorServices
                                      .overlayDark200
                                      .value
                                      .withValues(alpha: 0.3),
                                  blurRadius: 32,
                                  spreadRadius: -6,
                                  offset: Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_origin.svg",
                                              width: 13.33,
                                              height: 13.33,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .advancedBooking
                                                  .value
                                                  .startAddress ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .captionLargeBold
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                DashedLine(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                SizedBox(height: 4),
                                Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_pinpoint.svg",
                                              width: 12,
                                              height: 14,
                                              colorFilter: ColorFilter.mode(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorRed400
                                                    .value,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .advancedBooking
                                                  .value
                                                  .endAddress ??
                                              "-",
                                          style: controller
                                              .typographyServices
                                              .captionLargeBold
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AdvancedBookingWaitingDriverAcceptancePanelSubView(),
          ],
        ),
      ),
    );
  }
}
