import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/controllers/create_order_ride_promo_controller.dart';

class PromoAvailableCardSubView
    extends GetView<CreateOrderRidePromoController> {
  final Coupon coupon;
  const PromoAvailableCardSubView({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.onTapCoupon(coupon),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: controller.selectedCouponId.value == coupon.id
                ? Color(0XFFEDF6FF)
                : controller.themeColorServices.neutralsColorGrey0.value,
            border: Border.all(
              color: controller.selectedCouponId.value == coupon.id
                  ? Color(0XFF7AC0F8)
                  : Color(0XFFE6E6E6),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/icons/icon_promo.svg",
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  controller.selectedCouponId.value == coupon.id
                      ? controller.themeColorServices.primaryBlue.value
                      : Color(0XFF2E2E2E),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(coupon.money),
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(
                                fontSize: 18,
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey700
                                    .value,
                              ),
                        ),
                        if (coupon.fullMoney != 0 &&
                            coupon.fullMoney != null) ...[
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${controller.languageServices.language.value.minOrder ?? "-"} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(coupon.fullMoney)}",
                              style: controller
                                  .typographyServices
                                  .captionLargeRegular
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        text:
                            controller
                                .languageServices
                                .language
                                .value
                                .promotionAvailable ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                " · ${controller.languageServices.language.value.validUntil ?? "-"} ${coupon.time}",
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
                  ],
                ),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () => controller.onTapCoupon(coupon),
                child: AbsorbPointer(
                  child: RadioGroup(
                    groupValue: controller.selectedCouponId.value,
                    onChanged: (_) => controller.onTapCoupon(coupon),
                    child: Radio(
                      value: int.parse(coupon.id.toString()),
                      activeColor:
                          controller.themeColorServices.primaryBlue.value,
                      backgroundColor:
                          controller.selectedCouponId.value == coupon.id
                          ? WidgetStateProperty.all(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue100
                                  .value,
                            )
                          : WidgetStateProperty.all(
                              controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
