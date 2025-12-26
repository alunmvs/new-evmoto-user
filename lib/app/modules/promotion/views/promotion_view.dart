import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

import '../controllers/promotion_controller.dart';

class PromotionView extends GetView<PromotionController> {
  const PromotionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Semua Promosi",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      backgroundColor:
          controller.themeColorServices.neutralsColorSlate100.value,
      body: RefreshIndicator(
        color: controller.themeColorServices.primaryBlue.value,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.VOUCHER_DETAIL);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: controller
                              .themeColorServices
                              .overlayDark100
                              .value
                              .withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 311 / 155,
                            child: Image.asset(
                              "assets/images/img_promo_1.png",
                              height: 155,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "21 Februari 2025 - 20 Mei 2025",
                          style: controller
                              .typographyServices
                              .captionLargeRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorSlate300
                                    .value,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Perjalanan ke Bandara Soekarno Hatta Cengkareng",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey100
                                .value,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_voucher.svg",
                                height: 14,
                                width: 14,
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey700
                                    .value,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "EVMOTOPROMO2025",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0XFFFFFFFF),
                                    Color(0XFFCDE2F8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Minimal Transaksi Rp50.000",
                                  style: controller
                                      .typographyServices
                                      .captionLargeBold
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .sematicColorBlue600
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.5,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                "Gunakan Promo",
                                style: controller
                                    .typographyServices
                                    .captionLargeBold
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
