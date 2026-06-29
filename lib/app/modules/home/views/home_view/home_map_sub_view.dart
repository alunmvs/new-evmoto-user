import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeMapSubView extends GetView<HomeController> {
  const HomeMapSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SizedBox(height: 65),
          SizedBox(
            height: MediaQuery.of(context).size.width / (375 / 369),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 375 / 369,
                  child: Animarker(
                    mapId: controller.googleMapController.future.then<int>(
                      (value) => value.mapId,
                    ),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                    markers: Set<Marker>.from(controller.markers.values),
                    shouldAnimateCamera: false,
                    useRotation: true,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      // onCameraIdle: () {
                      //   controller.customGestureEnabled.value = true;
                      // },
                      onCameraMove: (position) async {
                        if (controller.isFetch.value == true) {
                          return;
                        }
                        controller.currentLatitude.value =
                            position.target.latitude;
                        controller.currentLongitude.value =
                            position.target.longitude;
                      },
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      // zoomGesturesEnabled: false,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      indoorViewEnabled: false,
                      // gestureRecognizers:
                      //     <Factory<OneSequenceGestureRecognizer>>{
                      //       Factory<ScaleGestureRecognizer>(() {
                      //         final recognizer = ScaleGestureRecognizer();
                      //         recognizer.onStart = (_) {
                      //           /* ... */
                      //           print("ini scale start");
                      //         };
                      //         recognizer.onUpdate = (details) async {
                      //           print("ini scale update");
                      //           /* logika zoom */
                      //           if (details.pointerCount < 2) return;

                      //           if (!controller.isMapPinching.value) {
                      //             controller.isMapPinching.value = true;
                      //             final currentZoom =
                      //                 controller.updateZoom.value > 0
                      //                 ? controller.updateZoom.value
                      //                 : controller
                      //                       .initialCameraPosition
                      //                       .value
                      //                       .zoom;
                      //             controller.startZoom.value = currentZoom;
                      //             controller.cameraPosition.value =
                      //                 CameraPosition(
                      //                   target: LatLng(
                      //                     controller.currentLatitude.value!,
                      //                     controller.currentLongitude.value!,
                      //                   ),
                      //                   zoom: currentZoom,
                      //                 );
                      //           }

                      //           final zoom =
                      //               controller.startZoom.value +
                      //               math.log(details.scale) / math.ln2;
                      //           controller.updateZoom.value = zoom;

                      //           await (await controller
                      //                   .googleMapController
                      //                   .future)
                      //               .moveCamera(
                      //                 CameraUpdate.newCameraPosition(
                      //                   CameraPosition(
                      //                     target: controller
                      //                         .cameraPosition
                      //                         .value!
                      //                         .target,
                      //                     zoom: zoom,
                      //                   ),
                      //                 ),
                      //               );
                      //         };
                      //         recognizer.onEnd = (_) async {
                      //           print("ini scale end");
                      //           /* ... */
                      //           if (!controller.isMapPinching.value) return;

                      //           controller.isMapPinching.value = false;
                      //           await (await controller
                      //                   .googleMapController
                      //                   .future)
                      //               .moveCamera(
                      //                 CameraUpdate.newCameraPosition(
                      //                   CameraPosition(
                      //                     target: controller
                      //                         .cameraPosition
                      //                         .value!
                      //                         .target,
                      //                     zoom: controller.updateZoom.value,
                      //                   ),
                      //                 ),
                      //               );
                      //         };
                      //         return recognizer;
                      //       }),
                      //     },
                      initialCameraPosition:
                          controller.initialCameraPosition.value,
                      onMapCreated:
                          (GoogleMapController googleMapController) async {
                            controller.googleMapController.complete(
                              googleMapController,
                            );
                            await controller
                                .moveGoogleMapCameraToCurrentLocation();
                          },
                    ),
                  ),
                ),
                // if (controller.customGestureEnabled.value == true)
                //   AspectRatio(
                //     aspectRatio: 375 / 369,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.opaque,
                //       onScaleStart: (_) {},
                //       onLongPress: () {
                //         print("ini long press move update");
                //       },
                //       onScaleUpdate: (details) async {
                //         print(
                //           "ini long press move update ${details.pointerCount}",
                //         );
                //         // if (details.pointerCount == 1) {
                //         //   controller.customGestureEnabled.value = false;
                //         // }
                //         if (details.pointerCount < 2) return;

                //         if (!controller.isMapPinching.value) {
                //           controller.isMapPinching.value = true;
                //           final currentZoom = controller.updateZoom.value > 0
                //               ? controller.updateZoom.value
                //               : controller.initialCameraPosition.value.zoom;
                //           controller.startZoom.value = currentZoom;
                //           controller.cameraPosition.value = CameraPosition(
                //             target: LatLng(
                //               controller.currentLatitude.value!,
                //               controller.currentLongitude.value!,
                //             ),
                //             zoom: currentZoom,
                //           );
                //         }

                //         final zoom =
                //             controller.startZoom.value +
                //             math.log(details.scale) / math.ln2;
                //         controller.updateZoom.value = zoom;

                //         await (await controller.googleMapController.future)
                //             .moveCamera(
                //               CameraUpdate.newCameraPosition(
                //                 CameraPosition(
                //                   target:
                //                       controller.cameraPosition.value!.target,
                //                   zoom: zoom,
                //                 ),
                //               ),
                //             );
                //       },
                //       onScaleEnd: (details) async {
                //         if (!controller.isMapPinching.value) return;

                //         controller.isMapPinching.value = false;
                //         await (await controller.googleMapController.future)
                //             .moveCamera(
                //               CameraUpdate.newCameraPosition(
                //                 CameraPosition(
                //                   target:
                //                       controller.cameraPosition.value!.target,
                //                   zoom: controller.updateZoom.value,
                //                 ),
                //               ),
                //             );
                //       },
                //       child: Container(color: Colors.transparent),
                //     ),
                //   ),
                Center(
                  child: SizedBox(
                    width: 64 + 70 + 64,
                    height: 38 + 55 + 38,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 33,
                            height: 39,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_pinpoint_map_home_blue.svg",
                                  width: 16,
                                  height: 30.51,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Positioned(
                        //   top: 0,
                        //   left: 0,
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       await controller.onTapWhereAreYouGoingToday();
                        //     },
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Container(
                        //           padding: EdgeInsets.symmetric(
                        //             horizontal: 8,
                        //             vertical: 4,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: controller
                        //                 .themeColorServices
                        //                 .primaryBlue
                        //                 .value,
                        //             borderRadius: BorderRadius.only(
                        //               topLeft: Radius.circular(6),
                        //               topRight: Radius.circular(6),
                        //             ),
                        //           ),
                        //           child: Text(
                        //             controller
                        //                     .languageServices
                        //                     .language
                        //                     .value
                        //                     .pickupPoint ??
                        //                 "-",
                        //             style: controller
                        //                 .typographyServices
                        //                 .captionLargeRegular
                        //                 .value
                        //                 .copyWith(
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //           ),
                        //         ),
                        //         Container(
                        //           constraints: BoxConstraints(maxWidth: 200),
                        //           padding: EdgeInsets.symmetric(
                        //             horizontal: 8,
                        //             vertical: 5,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: Color(0xffffffff),
                        //             borderRadius: BorderRadius.only(
                        //               topRight: Radius.circular(6),
                        //               bottomRight: Radius.circular(6),
                        //               bottomLeft: Radius.circular(6),
                        //             ),
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               if (controller
                        //                           .currentAddressIsLoading
                        //                           .value ==
                        //                       true ||
                        //                   controller
                        //                           .isCurrentAddressIsInit
                        //                           .value ==
                        //                       false) ...[
                        //                 Shimmer.fromColors(
                        //                   baseColor: Colors.grey.shade300,
                        //                   highlightColor: Colors.white,
                        //                   child: Container(
                        //                     height: 18,
                        //                     width: 150,
                        //                     decoration: BoxDecoration(
                        //                       color: Colors.grey.shade300,
                        //                       borderRadius:
                        //                           BorderRadius.circular(8),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ] else ...[
                        //                 Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     Container(
                        //                       constraints: BoxConstraints(
                        //                         maxWidth: 175 - 11,
                        //                       ),
                        //                       child: Text(
                        //                         controller
                        //                                 .currentGeocodingAddress
                        //                                 .value
                        //                                 .name ??
                        //                             "-",
                        //                         style: controller
                        //                             .typographyServices
                        //                             .captionLargeRegular
                        //                             .value
                        //                             .copyWith(
                        //                               fontWeight:
                        //                                   FontWeight.w600,
                        //                             ),
                        //                         maxLines: 1,
                        //                         overflow: TextOverflow.ellipsis,
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 4),
                        //                     SizedBox(
                        //                       width: 16,
                        //                       height: 16,
                        //                       child: Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.center,
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.center,
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: [
                        //                           SvgPicture.asset(
                        //                             "assets/icons/icon_arrow_right.svg",
                        //                             width: 4.76,
                        //                             height: 8.65,
                        //                             colorFilter:
                        //                                 ColorFilter.mode(
                        //                                   Color(0XFF272727),
                        //                                   BlendMode.srcIn,
                        //                                 ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
