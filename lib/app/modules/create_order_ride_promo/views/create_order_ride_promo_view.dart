import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/create_order_ride_promo_controller.dart';

class CreateOrderRidePromoView extends GetView<CreateOrderRidePromoController> {
  const CreateOrderRidePromoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Promo",
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
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                for (var coupon in controller.couponList) ...[
                  if (coupon.state == 1) ...[],
                  if (coupon.state == 2) ...[],
                ],
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
