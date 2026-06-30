import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';

class RideOrderPaymentMethodSubView extends GetView<RideOrderDetailController> {
  const RideOrderPaymentMethodSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: controller.themeColorServices.neutralsColorGrey200.value,
        ),
        borderRadius: BorderRadius.circular(12),
        color: controller.themeColorServices.neutralsColorGrey0.value,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.languageServices.language.value.paymentMethod ?? "-",
            style: controller.typographyServices.bodySmallBold.value,
          ),
          SizedBox(height: 8),
          if (controller.orderRideDetail.value.payType == 2) ...[
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_wallet.svg",
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 11),
                Text(
                  controller.languageServices.language.value.evmotoBalance ??
                      "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
                Spacer(),
                if (controller.orderRideDetail.value.couponId != 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controller.themeColorServices.primaryBlue.value,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      controller.languageServices.language.value.promo ?? "-",
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(controller.orderRideDetail.value.payMoney),
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
              ],
            ),
          ],
          if (controller.orderRideDetail.value.payType == 3) ...[
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_cash.svg",
                        fit: BoxFit.fitWidth,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 11),
                Text(
                  controller.languageServices.language.value.cash ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
                Spacer(),

                if (controller.orderRideDetail.value.couponId != 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controller.themeColorServices.primaryBlue.value,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      controller.languageServices.language.value.promo ?? "-",
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(controller.orderRideDetail.value.payMoney),
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
              ],
            ),
          ],
          if (controller.orderRideDetail.value.payType == 4) ...[
            Row(
              children: [
                Image.asset(
                  "assets/icons/icon_payment_method_gopay.png",
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 11),
                Text(
                  "GoPay",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
                Spacer(),
                if (controller.orderRideDetail.value.couponId != 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controller.themeColorServices.primaryBlue.value,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      controller.languageServices.language.value.promo ?? "-",
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(controller.orderRideDetail.value.payMoney),
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
