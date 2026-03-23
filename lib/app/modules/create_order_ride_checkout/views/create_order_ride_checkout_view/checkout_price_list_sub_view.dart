import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';

class CheckoutPriceListSubView
    extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutPriceListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var orderRidePricing in controller.orderRidePricingList) ...[
            GestureDetector(
              onTap: () {
                controller.selectedOrderRidePricing.value = orderRidePricing;
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      controller.selectedOrderRidePricing.value.id ==
                          orderRidePricing.id
                      ? Color(0XFFEDF6FF)
                      : Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(9.23),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_ride.svg",
                            width: 23.38,
                            height: 17.31,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      orderRidePricing.name ?? "-",
                      style: controller.typographyServices.bodySmallBold.value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorSlate800
                                .value,
                          ),
                    ),
                    SizedBox(width: 4),
                    SvgPicture.asset(
                      "assets/icons/icon_account.svg",
                      width: 12,
                      height: 12,
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey400
                          .value,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "1",
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    SizedBox(width: 8),
                    if (orderRidePricing.discountMoney != null &&
                        orderRidePricing.discountMoney != 0.0) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          controller.languageServices.language.value.promo ??
                              "-",
                          style: controller
                              .typographyServices
                              .captionSmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                              ),
                        ),
                      ),
                    ],
                    SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(
                            orderRidePricing.discountMoney == null
                                ? orderRidePricing.amount!
                                : (orderRidePricing.amount! -
                                      orderRidePricing.discountMoney!),
                          ),
                          style:
                              controller.typographyServices.bodyLargeBold.value,
                        ),
                        if (orderRidePricing.discountMoney != null &&
                            orderRidePricing.discountMoney != 0.0) ...[
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(orderRidePricing.amount ?? 0.0),
                            style: controller
                                .typographyServices
                                .captionLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(width: 18),
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fillColor: WidgetStatePropertyAll(
                        controller.selectedOrderRidePricing.value.id ==
                                orderRidePricing.id
                            ? controller.themeColorServices.primaryBlue.value
                            : controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                      ),
                      activeColor: Colors.white,
                      side: BorderSide(
                        color:
                            controller.selectedOrderRidePricing.value.id ==
                                orderRidePricing.id
                            ? controller.themeColorServices.primaryBlue.value
                            : Color(0XFFD7D7D7),
                        width: 2,
                      ),
                      value:
                          controller.selectedOrderRidePricing.value.id ==
                          orderRidePricing.id,
                      onChanged: (value) {
                        controller.selectedOrderRidePricing.value =
                            orderRidePricing;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 0, color: Color(0XFFE9E9E9)),
          ],
        ],
      ),
    );
  }
}
