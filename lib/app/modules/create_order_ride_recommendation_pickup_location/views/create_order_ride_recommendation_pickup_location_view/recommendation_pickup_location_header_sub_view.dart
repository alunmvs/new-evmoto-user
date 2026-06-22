import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_recommendation_pickup_location/controllers/create_order_ride_recommendation_pickup_location_controller.dart';

class RecommendationPickupLocationHeaderSubView
    extends GetView<CreateOrderRideRecommendationPickupLocationController> {
  const RecommendationPickupLocationHeaderSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 96,
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
    );
  }
}
