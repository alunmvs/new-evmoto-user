import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

import '../controllers/promotion_controller.dart';

class PromotionView extends GetView<PromotionController> {
  const PromotionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Semua Promosi",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor:
            controller.themeColorServices.neutralsColorSlate100.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : RefreshIndicator(
                color: controller.themeColorServices.primaryBlue.value,
                backgroundColor:
                    controller.themeColorServices.neutralsColorGrey0.value,
                onRefresh: () async {},
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        if (controller.availableCouponList.isEmpty) ...[
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 134),
                                Text(
                                  "Belum Ada Promosi Tersedia",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Tenang, promo menarik sedang kami siapkan. Stay tuned dan cek kembali ya!",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                        for (var availableCoupon
                            in controller.availableCouponList) ...[
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.VOUCHER_DETAIL,
                                arguments: {
                                  "coupon_detail": availableCoupon,
                                  "is_select_coupon": false,
                                },
                              );
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
                                      child: Placeholder(),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Berakhir pada : ${availableCoupon.time}",
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
                                    availableCoupon.name ?? "-",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            availableCoupon.type == 1
                                                ? "Tidak Ada Minimal Transaksi"
                                                : "Minimal Transaksi ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(availableCoupon.fullMoney)}",
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
