import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view/create_order_ride_saved_address_sub_view.dart';

class CreateOrderRideTextFieldDestinationOriginSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideTextFieldDestinationOriginSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              SvgPicture.asset(
                "assets/icons/icon_connector_origin_destination.svg",
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autofocus: false,
                  focusNode: controller.focusNodeOrigin,
                  controller: controller.originTextEditingController,
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue600
                            .value,
                      ),
                  onChanged: (value) {
                    controller.keywordOrigin.value = value;
                    controller.getOriginPlaceLocationList(keyword: value);
                  },
                  onTap: () {
                    if (controller.originTextEditingController.text == "") {
                      controller.originGeocodingPlaceList.value = [];
                    }
                    controller.isOriginHasPrimaryFocus.value = true;
                    controller.isDestinationHasPrimaryFocus.value = false;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText:
                        controller
                            .languageServices
                            .language
                            .value
                            .enterPickupLocation ??
                        "-",
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
                    fillColor: controller.isOriginHasPrimaryFocus() == true
                        ? Color(0XFFF5FAFF)
                        : controller.isLatLngOriginFilled()
                        ? Color(0XFFF3F3F3)
                        : Color(0XFFFFFFFF),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: controller.isOriginHasPrimaryFocus() == true
                            ? Color(0XFF5B94D2)
                            : Color(0XFFE6E6E6),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: controller.isOriginHasPrimaryFocus() == true
                            ? Color(0XFF5B94D2)
                            : Color(0XFFE6E6E6),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: controller.isOriginHasPrimaryFocus() == true
                            ? Color(0XFF5B94D2)
                            : Color(0XFFE6E6E6),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 24),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 12),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_pinpoint_green.svg",
                                width: 16.5,
                                height: 21.21,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    suffixIconConstraints:
                        controller.keywordOrigin.value == "" &&
                            controller.originAddress.value == ""
                        ? null
                        : BoxConstraints(minWidth: 24),
                    suffixIcon:
                        controller.keywordOrigin.value == "" &&
                            controller.originAddress.value == ""
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.keywordOrigin.value = "";
                                  controller.originTextEditingController.text =
                                      "";
                                  controller.originAddress.value = "";
                                  controller.originLatitude.value = "";
                                  controller.originLongitude.value = "";
                                  controller.originGeocodingPlace.value =
                                      GeocodingPlace();
                                  controller.originGeocodingPlaceList.value =
                                      [];

                                  controller.focusNodeOrigin.requestFocus();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: 24,
                                  height: 24,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_close.svg",
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          controller
                                              .themeColorServices
                                              .neutralsColorSlate700
                                              .value,
                                          BlendMode.srcIn,
                                        ),
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
                SizedBox(height: 12),
                TextField(
                  autofocus: false,
                  canRequestFocus: controller.isLatLngOriginFilled(),
                  focusNode: controller.focusNodeDestination,
                  controller: controller.destinationTextEditingController,
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue600
                            .value,
                      ),
                  readOnly: controller.isLatLngOriginFilled() == false,
                  onChanged: (value) {
                    controller.keywordDestination.value = value;
                    controller.getDestinationPlaceLocationList(keyword: value);
                  },
                  onTap: () {
                    if (controller.isLatLngOriginFilled() == true) {
                      if (controller.destinationTextEditingController.text ==
                          "") {
                        controller.destinationGeocodingPlaceList.value = [];
                      }
                      controller.isOriginHasPrimaryFocus.value = false;
                      controller.isDestinationHasPrimaryFocus.value = true;
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: controller
                        .languageServices
                        .language
                        .value
                        .enterDestinationLocation,
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
                        controller.isDestinationHasPrimaryFocus.value == true
                        ? Color(0XFFF5FAFF)
                        : controller.isLatLngDestinationFilled() ||
                              controller.isLatLngOriginFilled() == false
                        ? Color(0XFFF3F3F3)
                        : Color(0XFFFFFFFF),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0XFFE6E6E6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0XFFE6E6E6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0XFF5B94D2)),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 24),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 12),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_pinpoint_red.svg",
                                width: 16.5,
                                height: 21.21,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    suffixIconConstraints:
                        controller.keywordDestination.value == "" &&
                            controller.destinationAddress.value == ""
                        ? null
                        : BoxConstraints(minWidth: 24),
                    suffixIcon:
                        controller.keywordDestination.value == "" &&
                            controller.destinationAddress.value == ""
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  controller.keywordDestination.value = "";
                                  controller
                                          .destinationTextEditingController
                                          .text =
                                      "";
                                  controller.destinationAddress.value = "";
                                  controller.destinationLatitude.value = "";
                                  controller.destinationLongitude.value = "";
                                  controller.destinationGeocodingPlace.value =
                                      GeocodingPlace();
                                  controller
                                          .destinationGeocodingPlaceList
                                          .value =
                                      [];

                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );
                                  controller.focusNodeDestination
                                      .requestFocus();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: 24,
                                  height: 24,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_close.svg",
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          controller
                                              .themeColorServices
                                              .neutralsColorSlate700
                                              .value,
                                          BlendMode.srcIn,
                                        ),
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
                SizedBox(height: 12),
                CreateOrderRideSavedAddressSubView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
