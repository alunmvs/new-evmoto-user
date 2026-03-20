import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';

import '../../../../routes/app_pages.dart';

class CheckoutPaymentAndPromoSubView
    extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutPaymentAndPromoSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (controller.payType.value == 3) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_cash_1.svg",
                              width: 20,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.languageServices.language.value.cash ?? "-",
                        style:
                            controller.typographyServices.bodySmallBold.value,
                      ),
                    ],
                  ],
                ),
                SizedBox(width: 52),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: VerticalDivider(width: 0, color: Color(0XFFB9B9B9)),
                ),
                SizedBox(width: 38),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_discount.svg",
                            width: 16,
                            height: 16,
                            color: Color(0XFFB3B3B3),
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Tidak ada promo tersedia",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(color: Color(0XFFB3B3B3)),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: GestureDetector(
                //     onTap: () async {
                //       var result = await Get.toNamed(Routes.SELECT_PROMO);

                //       if (result != null) {
                //         controller.selectedCoupon.value = result;
                //         await controller.getOrderRidePricingList();
                //       }
                //     },
                //     child: Container(
                //       color: Colors.white,
                //       child: Row(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               SvgPicture.asset(
                //                 "assets/icons/icon_discount.svg",
                //                 width: 16,
                //                 height: 16,
                //               ),
                //             ],
                //           ),
                //           SizedBox(width: 4),
                //           Text(
                //             controller.selectedCoupon.value.id == null
                //                 ? "Pilih Promo"
                //                 : controller.selectedCoupon.value.id.toString(),
                //             style: controller
                //                 .typographyServices
                //                 .bodySmallBold
                //                 .value,
                //           ),
                //           Spacer(),
                //           SizedBox(width: 8),
                //           SvgPicture.asset(
                //             "assets/icons/icon_arrow_right.svg",
                //             width: 10.83 * 1.3,
                //             height: 6.25 * 1.3,
                //             color: Color(0XFF2E2E2E),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
