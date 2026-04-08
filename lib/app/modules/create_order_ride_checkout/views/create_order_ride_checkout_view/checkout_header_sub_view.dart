import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

class CheckoutHeaderSubView extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutHeaderSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0XFFFFFFFF), Color(0XFFFFFFFF).withValues(alpha: 0)],
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
                                            controller.originAddress.value ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallBold
                                                .value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SvgPicture.asset(
                                          "assets/icons/icon_arrow_right.svg",
                                          width: 6.44,
                                          height: 11.14,
                                          colorFilter: ColorFilter.mode(
                                            Color(0XFF072841),
                                            BlendMode.srcIn,
                                          ),
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        SvgPicture.asset(
                                          "assets/icons/icon_arrow_right.svg",
                                          width: 6.44,
                                          height: 11.14,
                                          colorFilter: ColorFilter.mode(
                                            Color(0XFF072841),
                                            BlendMode.srcIn,
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
