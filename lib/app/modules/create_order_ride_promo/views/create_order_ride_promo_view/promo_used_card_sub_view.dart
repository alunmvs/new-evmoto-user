import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/controllers/create_order_ride_promo_controller.dart';

class PromoUsedCardSubView extends GetView<CreateOrderRidePromoController> {
  final Coupon coupon;
  const PromoUsedCardSubView({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Color(0XFFF0F0F0),
            border: Border.all(color: Color(0XFFD3D3D3)),
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
                  Color(0XFF808080),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                        decimalDigits: 0,
                      ).format(coupon.money),
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(fontSize: 18, color: Color(0XFF808080)),
                    ),
                    SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        text:
                            controller
                                .languageServices
                                .language
                                .value
                                .promoHasBeenUsed ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey500
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
              RadioGroup(
                groupValue: controller.selectedCouponId.value,
                onChanged: (value) {},
                child: Radio(
                  value: coupon.id,
                  backgroundColor: WidgetStateProperty.all(Color(0XFFF0F0F0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
