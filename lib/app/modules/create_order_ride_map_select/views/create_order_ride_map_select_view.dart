import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:shimmer/shimmer.dart';

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
                      GoogleMap(
                        mapType: MapType.normal,
                        onCameraMove: controller.isFetch.value
                            ? null
                            : (position) async {
                                controller.latitude.value = position
                                    .target
                                    .latitude
                                    .toString();
                                controller.longitude.value = position
                                    .target
                                    .longitude
                                    .toString();
                                controller.updateLocationLatLng(
                                  latitude: position.target.latitude,
                                  longitude: position.target.longitude,
                                );
                              },
                        initialCameraPosition:
                            controller.initialCameraPosition.value,
                        onMapCreated:
                            (GoogleMapController googleMapController) async {
                              controller.googleMapController =
                                  googleMapController;

                              controller.isFetch.value = true;
                              await controller.fillForm();
                              controller.isFetch.value = false;
                            },
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
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.themeColorServices.overlayDark200.value
                          .withValues(alpha: 0.3),
                      blurRadius: 32,
                      spreadRadius: -6,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.type.value == "origin"
                                    ? "Lokasi Penjemputan"
                                    : "Lokasi Tujuan",
                                style: controller
                                    .typographyServices
                                    .bodyLargeBold
                                    .value,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Edit",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(width: 6),
                                      SvgPicture.asset(
                                        "assets/icons/icon_edit.svg",
                                        width: 12,
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        controller.type.value == "origin"
                                            ? "assets/icons/icon_pinpoint_green.svg"
                                            : "assets/icons/icon_pinpoint_red.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (controller.isFetchAddress.value ==
                                          true) ...[
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 18,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 18 * 2,
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          controller.addressName.value ?? "-",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          controller.address.value ?? "-",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        DashedLine(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey300
                              .value,
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LoaderElevatedButton(
                            onPressed: controller.isFetchAddress.value == true
                                ? null
                                : () async {
                                    controller.onTapSubmit();
                                  },
                            child: Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .confirmation ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
            Container(
              height: 96,
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
                children: [
                  SizedBox(height: 40),
                  Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
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
                              border: Border.all(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey300
                                    .value,
                              ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
