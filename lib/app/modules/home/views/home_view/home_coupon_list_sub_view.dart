import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class HomeCouponListSubView extends GetView<HomeController> {
  const HomeCouponListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.languageServices.language.value.promoToday ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value,
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.toNamed(Routes.PROMOTION);
                    await controller.refreshAll();
                  },
                  child: Text(
                    controller.languageServices.language.value.seeAll ?? "-",
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          if (controller.availableCouponList.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .noPromotionTitle ??
                        "-",
                    style: controller.typographyServices.bodyLargeBold.value,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .noPromotionDescription ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          if (controller.availableCouponList.isNotEmpty) ...[
            CarouselSlider(
              items: [
                for (var availableCoupon in controller.availableCouponList) ...[
                  Padding(
                    padding:
                        controller.availableCouponList.indexOf(
                              availableCoupon,
                            ) ==
                            0
                        ? EdgeInsets.only(left: 16)
                        : controller.availableCouponList.indexOf(
                                availableCoupon,
                              ) ==
                              controller.availableCouponList.length
                        ? EdgeInsets.only(left: 12)
                        : EdgeInsets.only(left: 12, right: 16),
                    child: GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.VOUCHER_DETAIL,
                          arguments: {"coupon_detail": availableCoupon},
                        );
                        await controller.refreshAll();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.transparent,
                          child: Placeholder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  controller.indexBanner.value = index.toDouble();
                },
                height: 155,
                enableInfiniteScroll: false,
                autoPlay: false,
                disableCenter: true,
                viewportFraction: 0.85,
                aspectRatio: 311 / 155,
                padEnds: false,
              ),
            ),
            if (controller.availableCouponList.length > 1) ...[
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DotsIndicator(
                  dotsCount: controller.availableCouponList.length,
                  position: controller.indexBanner.value,
                  decorator: DotsDecorator(
                    spacing: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey300
                        .value,
                    activeColor:
                        controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
