import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/views/create_order_ride_promo_view/promo_available_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/views/create_order_ride_promo_view/promo_unavailable_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/views/create_order_ride_promo_view/promo_used_card_sub_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/create_order_ride_promo_controller.dart';

class CreateOrderRidePromoView extends GetView<CreateOrderRidePromoController> {
  const CreateOrderRidePromoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop == false) {
            Get.back(result: controller.selectedCoupon.value);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              controller.languageServices.language.value.promo ?? "-",
              selectionColor:
                  controller.themeColorServices.neutralsColorGrey600.value,

              style: controller.typographyServices.bodyLargeBold.value,
            ),
            centerTitle: false,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            surfaceTintColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            titleSpacing: 16,
          ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          body: SmartRefresher(
            header: MaterialClassicHeader(
              color: controller.themeColorServices.primaryBlue.value,
            ),
            footer: ClassicFooter(
              loadStyle: LoadStyle.HideAlways,
              textStyle: controller.typographyServices.bodySmallRegular.value
                  .copyWith(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
              canLoadingIcon: null,
              loadingIcon: null,
              idleIcon: null,
              noMoreIcon: null,
              failedIcon: null,
            ),
            enablePullDown: true,
            enablePullUp: controller.isSeeMoreCouponList.value,
            onRefresh: () async {
              await controller.getCouponList();
              controller.refreshController.refreshCompleted();
            },
            onLoading: () async {
              await controller.seeMoreCouponList();
              controller.refreshController.loadComplete();
            },
            controller: controller.refreshController,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    for (var coupon in controller.couponList) ...[
                      if (coupon.state == 1) ...[
                        PromoAvailableCardSubView(coupon: coupon),
                      ],
                      if (coupon.state == 2) ...[
                        if (coupon.couponStatus == "used") ...[
                          PromoUsedCardSubView(coupon: coupon),
                        ],
                        if (coupon.couponStatus == "expired")
                          PromoExpiredCardSubView(coupon: coupon),
                      ],
                      SizedBox(height: 12),
                    ],
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
