import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_estimated_distance_and_time_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_payment_and_promo_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_price_list_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class CheckoutFooterSubView extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutFooterSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
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
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
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
                        CheckoutPriceListSubView(),
                        Container(
                          height: 6,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Color(0XFFE8E8E8)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LoaderElevatedButton(
                            isShowLoading: false,
                            onPressed:
                                controller.selectedOrderRidePricing.value.id ==
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
    );
  }
}
