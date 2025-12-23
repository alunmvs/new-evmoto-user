import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/data/models/google_geo_code_search_model.dart';
import 'package:new_evmoto_user/app/data/models/google_place_text_search_model.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/ride_controller.dart';

class RideView extends GetView<RideController> {
  const RideView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          switch (controller.status.value) {
            case 'fill_origin_and_destination':
              if (didPop == false) {
                Get.back();
              }
              return;
            case 'origin_select_via_map':
              controller.status.value = 'fill_origin_and_destination';
              return;
            case 'destination_select_via_map':
              controller.status.value = 'fill_origin_and_destination';
              return;
            case 'checkout':
              controller.status.value = 'fill_origin_and_destination';
              return;
            default:
              return;
          }
        },
        child: Container(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: controller.status.value == "done"
                ? AppBar(
                    title: Text(
                      "Order Selesai",
                      style: controller.typographyServices.bodyLargeBold.value,
                    ),
                    centerTitle: false,
                    backgroundColor:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    surfaceTintColor:
                        controller.themeColorServices.neutralsColorGrey0.value,

                    leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_close.svg",
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            onCameraMove: (position) async {
                              if (controller.status.value ==
                                  "origin_select_via_map") {
                                await controller
                                    .onMapMoveOriginGoogleGeoCodeSearch(
                                      latitude: position.target.latitude
                                          .toString(),
                                      longitude: position.target.longitude
                                          .toString(),
                                    );
                              }
                              if (controller.status.value ==
                                  "destination_select_via_map") {
                                await controller
                                    .onMapMoveDestinationGoogleGeoCodeSearch(
                                      latitude: position.target.latitude
                                          .toString(),
                                      longitude: position.target.longitude
                                          .toString(),
                                    );
                              }
                            },
                            initialCameraPosition:
                                controller.initialCameraPosition.value,
                            onMapCreated:
                                (GoogleMapController googleMapController) {
                                  controller.googleMapController =
                                      googleMapController;
                                  controller.prefillOrderAgain();
                                },
                            markers:
                                controller.isHideMarkersAndPolylines.value ==
                                    false
                                ? controller.markers
                                : {},
                            polylines:
                                controller.isHideMarkersAndPolylines.value ==
                                    false
                                ? controller.polylines
                                : {},
                          ),
                          if (controller.status.value ==
                                  "origin_select_via_map" ||
                              controller.status.value ==
                                  "destination_select_via_map") ...[
                            Center(
                              child: SvgPicture.asset(
                                controller.status.value ==
                                        "origin_select_via_map"
                                    ? "assets/icons/icon_origin.svg"
                                    : "assets/icons/icon_pinpoint.svg",
                                width:
                                    controller.status.value ==
                                        "origin_select_via_map"
                                    ? 22.67
                                    : 18,
                                height:
                                    controller.status.value ==
                                        "origin_select_via_map"
                                    ? 22.67
                                    : 21,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (150 / 812),
                    ),
                  ],
                ),
                if (controller.isFetch.value) ...[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                      ),
                    ),
                  ),
                ],
                if (controller.isFetch.value == false) ...[
                  if (controller.status.value ==
                      "fill_origin_and_destination") ...[
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                    SlidingUpPanel(
                      controller:
                          controller.fillOriginAndDestinationPanelController,
                      minHeight: controller
                          .fillOriginAndDestinationPanelMinHeight
                          .value,
                      maxHeight: controller
                          .fillOriginAndDestinationPanelMaxHeight
                          .value,
                      padding: EdgeInsets.all(0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
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
                      panel: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Mau Kemana Hari Ini?",
                                            style: controller
                                                .typographyServices
                                                .bodyLargeBold
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey700
                                                      .value,
                                                ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await controller
                                                  .onTapSelectViaMap();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_maps.svg",
                                                    width: 16,
                                                    height: 16,
                                                    color: controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Pilih Lewat Peta",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
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
                                    ),
                                    SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                        child: Column(
                                          children: [
                                            TextField(
                                              focusNode:
                                                  controller.focusNodeOrigin,
                                              controller: controller
                                                  .originTextEditingController,
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue600
                                                        .value,
                                                  ),
                                              onChanged: (value) {
                                                controller.keywordOrigin.value =
                                                    value;
                                                controller
                                                    .getOriginPlaceLocationList(
                                                      keyword: value,
                                                    );
                                              },
                                              onTap: () {
                                                if (controller
                                                        .originTextEditingController
                                                        .text !=
                                                    "") {
                                                  controller
                                                      .getOriginPlaceLocationList(
                                                        keyword: controller
                                                            .originTextEditingController
                                                            .text,
                                                      );
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                hintText:
                                                    'Masukkan lokasi penjemputan',
                                                hintStyle: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey400
                                                          .value,
                                                    ),
                                                fillColor:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                filled: true,
                                                border:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      )
                                                    : InputBorder.none,
                                                enabledBorder:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      )
                                                    : InputBorder.none,
                                                focusedBorder:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      )
                                                    : InputBorder.none,
                                                prefixIconConstraints:
                                                    BoxConstraints(
                                                      minWidth: 24,
                                                    ),
                                                prefixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(width: 12),
                                                    SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_origin.svg",
                                                            width: 20,
                                                            height: 20,
                                                            color: controller
                                                                .themeColorServices
                                                                .neutralsColorSlate700
                                                                .value,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                suffixIconConstraints:
                                                    controller
                                                                .keywordOrigin
                                                                .value ==
                                                            "" &&
                                                        controller
                                                                .originAddress
                                                                .value ==
                                                            ""
                                                    ? null
                                                    : BoxConstraints(
                                                        minWidth: 24,
                                                      ),
                                                suffixIcon:
                                                    controller
                                                                .keywordOrigin
                                                                .value ==
                                                            "" &&
                                                        controller
                                                                .originAddress
                                                                .value ==
                                                            ""
                                                    ? null
                                                    : Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                      .keywordOrigin
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .originTextEditingController
                                                                      .text =
                                                                  "";
                                                              controller
                                                                      .originAddress
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .originLatitude
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .originLongitude
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .originGoogleGeoCodeSearch
                                                                      .value =
                                                                  GoogleGeoCodeSearch();
                                                              controller
                                                                      .originGooglePlaceTextSearch
                                                                      .value =
                                                                  GooglePlaceTextSearch();

                                                              controller
                                                                  .focusNodeOrigin
                                                                  .requestFocus();
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 24,
                                                              height: 24,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    "assets/icons/icon_close.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .neutralsColorSlate700
                                                                        .value,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                            TextField(
                                              autofocus: true,
                                              focusNode: controller
                                                  .focusNodeDestination,
                                              controller: controller
                                                  .destinationTextEditingController,
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue600
                                                        .value,
                                                  ),
                                              readOnly:
                                                  controller
                                                      .isLatLngOriginFilled() ==
                                                  false,
                                              onChanged: (value) {
                                                controller
                                                        .keywordDestination
                                                        .value =
                                                    value;
                                                controller
                                                    .getDestinationPlaceLocationList(
                                                      keyword: value,
                                                    );
                                              },
                                              onTap: () {
                                                if (controller
                                                        .originTextEditingController
                                                        .text !=
                                                    "") {
                                                  controller
                                                      .getDestinationPlaceLocationList(
                                                        keyword: controller
                                                            .originTextEditingController
                                                            .text,
                                                      );
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                hintText:
                                                    'Masukkan lokasi tujuan',
                                                hintStyle: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey400
                                                          .value,
                                                    ),
                                                fillColor:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? Colors.transparent
                                                    : controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                filled: true,
                                                border:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? InputBorder.none
                                                    : OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ),
                                                enabledBorder:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? InputBorder.none
                                                    : OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ),
                                                focusedBorder:
                                                    controller
                                                                .isLatLngOriginFilled() ==
                                                            false ||
                                                        controller
                                                                .isOriginHasPrimaryFocus
                                                                .value ==
                                                            true
                                                    ? InputBorder.none
                                                    : OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ),
                                                prefixIconConstraints:
                                                    BoxConstraints(
                                                      minWidth: 24,
                                                    ),
                                                prefixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(width: 12),
                                                    SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_pinpoint.svg",
                                                            width: 18,
                                                            height: 21,
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorRed400
                                                                .value,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                suffixIconConstraints:
                                                    controller
                                                                .keywordDestination
                                                                .value ==
                                                            "" &&
                                                        controller
                                                                .destinationAddress
                                                                .value ==
                                                            ""
                                                    ? null
                                                    : BoxConstraints(
                                                        minWidth: 24,
                                                      ),
                                                suffixIcon:
                                                    controller
                                                                .keywordDestination
                                                                .value ==
                                                            "" &&
                                                        controller
                                                                .destinationAddress
                                                                .value ==
                                                            ""
                                                    ? null
                                                    : Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                      .keywordDestination
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .destinationTextEditingController
                                                                      .text =
                                                                  "";
                                                              controller
                                                                      .destinationAddress
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .destinationLatitude
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .destinationLongitude
                                                                      .value =
                                                                  "";
                                                              controller
                                                                      .destinationGoogleGeoCodeSearch
                                                                      .value =
                                                                  GoogleGeoCodeSearch();
                                                              controller
                                                                      .destinationGooglePlaceTextSearch
                                                                      .value =
                                                                  GooglePlaceTextSearch();
                                                              controller
                                                                  .focusNodeDestination
                                                                  .requestFocus();
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 24,
                                                              height: 24,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    "assets/icons/icon_close.svg",
                                                                    width: 20,
                                                                    height: 20,
                                                                    color: controller
                                                                        .themeColorServices
                                                                        .neutralsColorSlate700
                                                                        .value,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 16),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.SEARCH_ADDRESS,
                                                arguments: {"address_type": 0},
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_home.svg",
                                                          height: 12,
                                                          width: 12,
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Tambah Rumah",
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
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.SEARCH_ADDRESS,
                                                arguments: {"address_type": 1},
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_office.svg",
                                                          height: 14,
                                                          width: 10,
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Tambah Kantor",
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
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.SEARCH_ADDRESS,
                                                arguments: {"address_type": 3},
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_add_square.svg",
                                                          height: 12,
                                                          width: 12,
                                                          color: controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "Lokasi Lainnya",
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
                                          ),
                                          SizedBox(width: 16),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    DashedLine(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    SizedBox(height: 2),
                                    if (controller
                                            .isOriginHasPrimaryFocus
                                            .value ==
                                        true) ...[
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (controller
                                                  .originGooglePlaceTextSearchList
                                                  .isEmpty) ...[
                                                for (var recommendationOriginCurrentLocation
                                                    in controller
                                                        .recommendationOriginCurrentLocationList) ...[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                              .originLatitude
                                                              .value =
                                                          recommendationOriginCurrentLocation
                                                              .latitude!;
                                                      controller
                                                              .originLongitude
                                                              .value =
                                                          recommendationOriginCurrentLocation
                                                              .longitude!;
                                                      controller
                                                              .originAddress
                                                              .value =
                                                          recommendationOriginCurrentLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .keywordOrigin
                                                              .value =
                                                          recommendationOriginCurrentLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .originTextEditingController
                                                              .text =
                                                          recommendationOriginCurrentLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                          .focusNodeDestination
                                                          .requestFocus();

                                                      controller.markers
                                                          .removeWhere(
                                                            (m) =>
                                                                m
                                                                    .markerId
                                                                    .value ==
                                                                'origin',
                                                          );
                                                      controller.markers.add(
                                                        Marker(
                                                          markerId: MarkerId(
                                                            "origin",
                                                          ),
                                                          position: LatLng(
                                                            double.parse(
                                                              recommendationOriginCurrentLocation
                                                                  .latitude!,
                                                            ),
                                                            double.parse(
                                                              recommendationOriginCurrentLocation
                                                                  .longitude!,
                                                            ),
                                                          ),
                                                          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
                                                            'assets/icons/icon_origin.svg',
                                                            Size(22.67, 22.67),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        top: 14,
                                                        left: 16,
                                                        right: 16,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .sematicColorBlue100
                                                                  .value,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_pinpoint.svg",
                                                                  width: 13.5,
                                                                  height: 15.75,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .sematicColorBlue500
                                                                      .value,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationOriginCurrentLocation
                                                                          .name ??
                                                                      recommendationOriginCurrentLocation
                                                                          .addressDetail!,
                                                                  words: controller
                                                                      .highlightedWordTitleAddressOrigin,
                                                                  textStyle: controller
                                                                      .typographyServices
                                                                      .bodySmallBold
                                                                      .value,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationOriginCurrentLocation
                                                                          .addressDetail ??
                                                                      "-",
                                                                  words: controller
                                                                      .highlightedWordAddressOrigin,
                                                                  textStyle: controller
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
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey200
                                                        .value,
                                                  ),
                                                ],
                                                for (var recommendationOriginLocation
                                                    in controller
                                                        .recommendationOriginLocationList) ...[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                              .originLatitude
                                                              .value =
                                                          recommendationOriginLocation
                                                              .latitude!;
                                                      controller
                                                              .originLongitude
                                                              .value =
                                                          recommendationOriginLocation
                                                              .longitude!;
                                                      controller
                                                              .originAddress
                                                              .value =
                                                          recommendationOriginLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .keywordOrigin
                                                              .value =
                                                          recommendationOriginLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .originTextEditingController
                                                              .text =
                                                          recommendationOriginLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                          .focusNodeDestination
                                                          .requestFocus();

                                                      controller.markers
                                                          .removeWhere(
                                                            (m) =>
                                                                m
                                                                    .markerId
                                                                    .value ==
                                                                'origin',
                                                          );
                                                      controller.markers.add(
                                                        Marker(
                                                          markerId: MarkerId(
                                                            "origin",
                                                          ),
                                                          position: LatLng(
                                                            double.parse(
                                                              recommendationOriginLocation
                                                                  .latitude!,
                                                            ),
                                                            double.parse(
                                                              recommendationOriginLocation
                                                                  .longitude!,
                                                            ),
                                                          ),
                                                          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
                                                            'assets/icons/icon_origin.svg',
                                                            Size(22.67, 22.67),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        top: 14,
                                                        left: 16,
                                                        right: 16,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .sematicColorBlue100
                                                                  .value,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_pinpoint.svg",
                                                                  width: 13.5,
                                                                  height: 15.75,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .sematicColorBlue500
                                                                      .value,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationOriginLocation
                                                                          .name ??
                                                                      recommendationOriginLocation
                                                                          .addressDetail!,
                                                                  words: controller
                                                                      .highlightedWordTitleAddressOrigin,
                                                                  textStyle: controller
                                                                      .typographyServices
                                                                      .bodySmallBold
                                                                      .value,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationOriginLocation
                                                                          .addressDetail ??
                                                                      "-",
                                                                  words: controller
                                                                      .highlightedWordAddressOrigin,
                                                                  textStyle: controller
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
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey200
                                                        .value,
                                                  ),
                                                ],
                                              ],
                                              for (var originGooglePlaceTextSearch
                                                  in controller
                                                      .originGooglePlaceTextSearchList) ...[
                                                GestureDetector(
                                                  onTap: () async {
                                                    controller
                                                            .originLatitude
                                                            .value =
                                                        originGooglePlaceTextSearch
                                                            .geometry!
                                                            .location!
                                                            .lat
                                                            .toString();
                                                    controller
                                                            .originLongitude
                                                            .value =
                                                        originGooglePlaceTextSearch
                                                            .geometry!
                                                            .location!
                                                            .lng
                                                            .toString();
                                                    controller
                                                            .originGooglePlaceTextSearch
                                                            .value =
                                                        originGooglePlaceTextSearch;
                                                    controller
                                                            .originAddress
                                                            .value =
                                                        originGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller
                                                            .keywordOrigin
                                                            .value =
                                                        originGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller
                                                            .originTextEditingController
                                                            .text =
                                                        originGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller
                                                        .focusNodeDestination
                                                        .requestFocus();

                                                    controller.markers
                                                        .removeWhere(
                                                          (m) =>
                                                              m
                                                                  .markerId
                                                                  .value ==
                                                              'origin',
                                                        );
                                                    controller.markers.add(
                                                      Marker(
                                                        markerId: MarkerId(
                                                          "origin",
                                                        ),
                                                        position: LatLng(
                                                          double.parse(
                                                            controller
                                                                .originLatitude
                                                                .value,
                                                          ),
                                                          double.parse(
                                                            controller
                                                                .originLongitude
                                                                .value,
                                                          ),
                                                        ),
                                                        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
                                                          'assets/icons/icon_origin.svg',
                                                          Size(22.67, 22.67),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    padding: EdgeInsets.only(
                                                      bottom: 8,
                                                      top: 14,
                                                      left: 16,
                                                      right: 16,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorBlue100
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_pinpoint.svg",
                                                                width: 13.5,
                                                                height: 15.75,
                                                                color: controller
                                                                    .themeColorServices
                                                                    .sematicColorBlue500
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextHighlight(
                                                                text:
                                                                    originGooglePlaceTextSearch
                                                                        .name ??
                                                                    "-",
                                                                words: controller
                                                                    .highlightedWordTitleAddressOrigin,
                                                                textStyle: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              TextHighlight(
                                                                text:
                                                                    originGooglePlaceTextSearch
                                                                        .formattedAddress ??
                                                                    "-",
                                                                words: controller
                                                                    .highlightedWordAddressOrigin,
                                                                textStyle: controller
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
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                              ],
                                              SizedBox(height: 32),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],

                                    if (controller
                                            .isDestinationHasPrimaryFocus
                                            .value ==
                                        true) ...[
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (controller
                                                  .destinationGooglePlaceTextSearchList
                                                  .isEmpty) ...[
                                                for (var recommendationDestinationLocation
                                                    in controller
                                                        .recommendationDestinationLocationList) ...[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                              .destinationLatitude
                                                              .value =
                                                          recommendationDestinationLocation
                                                              .latitude!;
                                                      controller
                                                              .destinationLongitude
                                                              .value =
                                                          recommendationDestinationLocation
                                                              .longitude!;

                                                      controller
                                                          .focusNodeDestination
                                                          .requestFocus();
                                                      controller.status.value =
                                                          "checkout";
                                                      controller
                                                              .destinationAddress
                                                              .value =
                                                          recommendationDestinationLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .keywordDestination
                                                              .value =
                                                          recommendationDestinationLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller
                                                              .destinationTextEditingController
                                                              .text =
                                                          recommendationDestinationLocation
                                                              .addressDetail ??
                                                          "-";
                                                      controller.markers
                                                          .removeWhere(
                                                            (m) =>
                                                                m
                                                                    .markerId
                                                                    .value ==
                                                                'destination',
                                                          );
                                                      controller.markers.add(
                                                        Marker(
                                                          markerId: MarkerId(
                                                            "destination",
                                                          ),
                                                          position: LatLng(
                                                            double.parse(
                                                              controller
                                                                  .destinationLatitude
                                                                  .value,
                                                            ),
                                                            double.parse(
                                                              controller
                                                                  .destinationLongitude
                                                                  .value,
                                                            ),
                                                          ),
                                                          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
                                                            'assets/icons/icon_pinpoint.svg',
                                                            Size(27, 31),
                                                          ),
                                                        ),
                                                      );

                                                      await Future.wait([
                                                        controller
                                                            .generatePolylines(),
                                                        controller
                                                            .refocusMapsBound(),
                                                        controller
                                                            .getOrderRidePricingList(),
                                                      ]);
                                                      controller
                                                          .selectedOrderRidePricing
                                                          .value = controller
                                                          .orderRidePricingList
                                                          .first;
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      padding: EdgeInsets.only(
                                                        bottom: 8,
                                                        top: 14,
                                                        left: 16,
                                                        right: 16,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .sematicColorBlue100
                                                                  .value,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_pinpoint.svg",
                                                                  width: 13.5,
                                                                  height: 15.75,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .sematicColorBlue500
                                                                      .value,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationDestinationLocation
                                                                          .name ??
                                                                      recommendationDestinationLocation
                                                                          .addressDetail!,
                                                                  words: controller
                                                                      .highlightedWordTitleAddressOrigin,
                                                                  textStyle: controller
                                                                      .typographyServices
                                                                      .bodySmallBold
                                                                      .value,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                TextHighlight(
                                                                  text:
                                                                      recommendationDestinationLocation
                                                                          .addressDetail ??
                                                                      "-",
                                                                  words: controller
                                                                      .highlightedWordAddressOrigin,
                                                                  textStyle: controller
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
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey200
                                                        .value,
                                                  ),
                                                ],
                                              ],
                                              for (var destinationGooglePlaceTextSearch
                                                  in controller
                                                      .destinationGooglePlaceTextSearchList) ...[
                                                GestureDetector(
                                                  onTap: () async {
                                                    controller
                                                            .destinationLatitude
                                                            .value =
                                                        destinationGooglePlaceTextSearch
                                                            .geometry!
                                                            .location!
                                                            .lat
                                                            .toString();
                                                    controller
                                                            .destinationLongitude
                                                            .value =
                                                        destinationGooglePlaceTextSearch
                                                            .geometry!
                                                            .location!
                                                            .lng
                                                            .toString();
                                                    controller
                                                            .destinationGooglePlaceTextSearch
                                                            .value =
                                                        destinationGooglePlaceTextSearch;
                                                    controller
                                                        .focusNodeDestination
                                                        .requestFocus();
                                                    controller.status.value =
                                                        "checkout";
                                                    controller
                                                            .destinationAddress
                                                            .value =
                                                        destinationGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller
                                                            .keywordDestination
                                                            .value =
                                                        destinationGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller
                                                            .destinationTextEditingController
                                                            .text =
                                                        destinationGooglePlaceTextSearch
                                                            .formattedAddress ??
                                                        "-";
                                                    controller.markers
                                                        .removeWhere(
                                                          (m) =>
                                                              m
                                                                  .markerId
                                                                  .value ==
                                                              'destination',
                                                        );
                                                    controller.markers.add(
                                                      Marker(
                                                        markerId: MarkerId(
                                                          "destination",
                                                        ),
                                                        position: LatLng(
                                                          double.parse(
                                                            controller
                                                                .destinationLatitude
                                                                .value,
                                                          ),
                                                          double.parse(
                                                            controller
                                                                .destinationLongitude
                                                                .value,
                                                          ),
                                                        ),
                                                        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
                                                          'assets/icons/icon_pinpoint.svg',
                                                          Size(27, 31),
                                                        ),
                                                      ),
                                                    );

                                                    await Future.wait([
                                                      controller
                                                          .generatePolylines(),
                                                      controller
                                                          .refocusMapsBound(),
                                                      controller
                                                          .getOrderRidePricingList(),
                                                    ]);
                                                    controller
                                                        .selectedOrderRidePricing
                                                        .value = controller
                                                        .orderRidePricingList
                                                        .first;
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    padding: EdgeInsets.only(
                                                      bottom: 8,
                                                      top: 14,
                                                      left: 16,
                                                      right: 16,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            color: controller
                                                                .themeColorServices
                                                                .sematicColorBlue100
                                                                .value,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/icons/icon_pinpoint.svg",
                                                                width: 13.5,
                                                                height: 15.75,
                                                                color: controller
                                                                    .themeColorServices
                                                                    .sematicColorBlue500
                                                                    .value,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextHighlight(
                                                                text:
                                                                    destinationGooglePlaceTextSearch
                                                                        .name ??
                                                                    "-",
                                                                words: controller
                                                                    .highlightedWordTitleAddressOrigin,
                                                                textStyle: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              TextHighlight(
                                                                text:
                                                                    destinationGooglePlaceTextSearch
                                                                        .formattedAddress ??
                                                                    "-",
                                                                words: controller
                                                                    .highlightedWordAddressOrigin,
                                                                textStyle: controller
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
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                              ],
                                              SizedBox(height: 32),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (controller.status.value == "origin_select_via_map" ||
                      controller.status.value ==
                          "destination_select_via_map") ...[
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.status.value =
                                        "fill_origin_and_destination";
                                    controller.isHideMarkersAndPolylines.value =
                                        false;
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    controller.status.value ==
                                            "origin_select_via_map"
                                        ? "Penjemputan"
                                        : "Tujuan",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .sematicColorBlue200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                controller.status.value ==
                                                        "origin_select_via_map"
                                                    ? "assets/icons/icon_origin.svg"
                                                    : "assets/icons/icon_pinpoint.svg",
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
                                              Text(
                                                controller.status.value ==
                                                        "origin_select_via_map"
                                                    ? (controller
                                                              .originGoogleGeoCodeSearch
                                                              .value
                                                              .formattedAddress ??
                                                          "-")
                                                    : (controller
                                                              .destinationGoogleGeoCodeSearch
                                                              .value
                                                              .formattedAddress ??
                                                          "-"),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: SizedBox(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller.onTapSubmitViaMap();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Konfirmasi",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value
                                            .copyWith(color: Colors.white),
                                      ),
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
                  ],
                  if (controller.status.value == "checkout") ...[
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
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.status.value =
                                            "fill_origin_and_destination";
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                        GestureDetector(
                                          onTap: () {
                                            controller.status.value =
                                                "fill_origin_and_destination";
                                            controller.focusNodeOrigin
                                                .requestFocus();
                                          },
                                          child: Container(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                        .originAddress
                                                        .value,
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeBold
                                                        .value,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                        GestureDetector(
                                          onTap: () {
                                            controller.status.value =
                                                "fill_origin_and_destination";
                                            controller.focusNodeDestination
                                                .requestFocus();
                                          },
                                          child: Container(
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_pinpoint.svg",
                                                        width: 12,
                                                        height: 14,
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorRed400
                                                            .value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                        .destinationAddress
                                                        .value,
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeBold
                                                        .value,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                for (var orderRidePricing
                                    in controller.orderRidePricingList) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller
                                                .selectedOrderRidePricing
                                                .value =
                                            orderRidePricing;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                controller
                                                        .selectedOrderRidePricing
                                                        .value
                                                        .id ==
                                                    orderRidePricing.id
                                                ? controller
                                                      .themeColorServices
                                                      .sematicColorBlue200
                                                      .value
                                                : controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0XFFF5F9FF),
                                                    Color(0XFFCDE2F8),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: [0.0, 1.0],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(9.23),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_ride.svg",
                                                    width: 29.23,
                                                    height: 21.64,
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
                                                  Text(
                                                    orderRidePricing.name ??
                                                        "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodyLargeBold
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorSlate800
                                                              .value,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_account.svg",
                                                        width: 12,
                                                        height: 12,
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey400
                                                            .value,
                                                      ),
                                                      SizedBox(width: 2.5),
                                                      Text(
                                                        "1 Penumpang",
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey400
                                                                  .value,
                                                            ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    orderRidePricing.amount ??
                                                        0.0,
                                                  ),
                                                  style: controller
                                                      .typographyServices
                                                      .bodyLargeBold
                                                      .value,
                                                ),
                                                if (orderRidePricing
                                                            .discountMoney !=
                                                        null &&
                                                    orderRidePricing
                                                            .discountMoney !=
                                                        0.0) ...[
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'id_ID',
                                                      symbol: 'Rp',
                                                      decimalDigits: 0,
                                                    ).format(
                                                      orderRidePricing
                                                              .discountMoney ??
                                                          0.0,
                                                    ),
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value
                                                        .copyWith(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationColor: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey400
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(height: 16),
                                DashedLine(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                                ),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller
                                                  .onTapSelectPaymentBottomSheet();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  if (controller
                                                          .payType
                                                          .value ==
                                                      2) ...[
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorBlue100
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_wallet.svg",
                                                            width: 8,
                                                            height: 8,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Saldo ECGO",
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallBold
                                                          .value,
                                                    ),
                                                    SizedBox(width: 4),
                                                    SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_arrow_down.svg",
                                                            width: 8.67,
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  if (controller
                                                          .payType
                                                          .value ==
                                                      3) ...[
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorBlue100
                                                            .value,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_cash.svg",
                                                            width: 8,
                                                            height: 8,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Cash",
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallBold
                                                          .value,
                                                    ),
                                                    SizedBox(width: 4),
                                                    SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_arrow_down.svg",
                                                            width: 8.67,
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              var result = await Get.toNamed(
                                                Routes.SELECT_PROMO,
                                              );

                                              if (result != null) {
                                                controller
                                                        .selectedCoupon
                                                        .value =
                                                    result;
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_discount.svg",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    controller
                                                                .selectedCoupon
                                                                .value
                                                                .id ==
                                                            null
                                                        ? "Promo"
                                                        : controller
                                                              .selectedCoupon
                                                              .value
                                                              .id
                                                              .toString(),
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value,
                                                  ),
                                                  SizedBox(width: 4),
                                                  SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_arrow_down.svg",
                                                          width: 8.67,
                                                          height: 5,
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
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: SizedBox(
                                    height: 46,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (controller.payType.value == 2) {
                                          if (controller
                                                  .homeController
                                                  .userInfo
                                                  .value
                                                  .balance! <
                                              controller
                                                  .selectedOrderRidePricing
                                                  .value
                                                  .amount!) {
                                            var snackBar = SnackBar(
                                              behavior: SnackBarBehavior.fixed,
                                              backgroundColor: controller
                                                  .themeColorServices
                                                  .sematicColorRed400
                                                  .value,
                                              content: Text(
                                                "Saldo ECGO tidak mencukupi",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                    ),
                                              ),
                                            );
                                            rootScaffoldMessengerKey
                                                .currentState
                                                ?.showSnackBar(snackBar);
                                            return;
                                          }
                                        }
                                        await controller.requestOrderRide();
                                        Get.back();
                                        Get.toNamed(
                                          Routes.RIDE_ORDER_DETAIL,
                                          arguments: {
                                            "order_id": controller
                                                .requestedOrderRide
                                                .value
                                                .id
                                                .toString(),
                                            "order_type": 1,
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Pesan EV Moto",
                                        style: controller
                                            .typographyServices
                                            .bodyLargeBold
                                            .value
                                            .copyWith(color: Colors.white),
                                      ),
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
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
