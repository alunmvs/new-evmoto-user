import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_estimated_distance_and_time_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_payment_and_promo_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_price_list_sub_view.dart';

import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import '../controllers/create_order_ride_checkout_controller.dart';

class CreateOrderRideCheckoutView
    extends GetView<CreateOrderRideCheckoutController> {
  const CreateOrderRideCheckoutView({super.key});
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
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        controller.initialCameraPosition.value,
                    markers: controller.markers,
                    polylines: controller.polylines,
                    onMapCreated:
                        (GoogleMapController googleMapController) async {
                          controller.googleMapController = googleMapController;

                          controller.isFetch.value = true;
                          try {
                            await controller.getAvailableCouponList();

                            await Future.wait([
                              controller.generatePolylinesOpenMapsApi(),
                              controller.refocusMapsBound(),
                              controller.getOrderRidePricingList(),
                              controller.setLatitudeLongitudeMarker(),
                            ]);
                          } on DioException catch (e) {
                            Get.back();

                            SnackbarHelper.showSnackbarError(
                              text: e.error.toString(),
                            );
                          }
                          controller.isFetch.value = false;
                        },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (150 / 812),
                ),
              ],
            ),
            // if (controller.isFetch.value == true) ...[
            //   Container(
            //     height: MediaQuery.of(context).size.height,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       color: controller.themeColorServices.neutralsColorGrey0.value,
            //     ),
            //     child: Center(
            //       child: SizedBox(
            //         width: 25,
            //         height: 25,
            //         child: CircularProgressIndicator(
            //           color: controller.themeColorServices.primaryBlue.value,
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
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
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
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
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_connector_origin_destination_checkout.svg",
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          controller
                                              .createOrderRideController
                                              .focusNodeOrigin
                                              .requestFocus();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 17,
                                                height: 17,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_pinpoint_green.svg",
                                                      width: 11.69,
                                                      height: 15.03,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  controller
                                                          .originAddress
                                                          .value ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_right.svg",
                                                width: 6.44,
                                                height: 11.14,
                                                color: Color(0XFF072841),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DashedLine(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Get.back();
                                          controller
                                              .createOrderRideController
                                              .focusNodeDestination
                                              .requestFocus();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 17,
                                                height: 17,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_pinpoint_red.svg",
                                                      width: 11.69,
                                                      height: 15.03,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  controller
                                                          .destinationAddress
                                                          .value ??
                                                      "-",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_right.svg",
                                                width: 6.44,
                                                height: 11.14,
                                                color: Color(0XFF072841),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutEstimatedDistanceAndTimeSubView(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
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
                              CheckoutPriceListSubView(),
                              Container(
                                height: 6,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0XFFE8E8E8),
                                ),
                              ),
                              SizedBox(height: 16),
                              CheckoutPaymentAndPromoSubView(),
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
                                child: LoaderElevatedButton(
                                  onPressed:
                                      controller
                                              .selectedOrderRidePricing
                                              .value
                                              .id ==
                                          null
                                      ? null
                                      : () async {
                                          await controller.onTapSubmit();
                                        },
                                  child: Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .orderEvMoto ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
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
    );
  }
}
