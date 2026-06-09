import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/utils/general_helper.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutEstimatedDistanceAndTimeSubView
    extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutEstimatedDistanceAndTimeSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (controller.isFetch.value == true) ...[
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 18 * 1.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
            if (controller.isFetch.value == false) ...[
              Expanded(
                child: Text(
                  "${controller.languageServices.language.value.distance} ${formatDoubleToString(controller.selectedOrderRidePricing.value.mileage ?? 0.0)} ${controller.languageServices.language.value.km} ·󠁏󠁏 ${controller.getEstimatedTimeInMinutesInText()}",
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
