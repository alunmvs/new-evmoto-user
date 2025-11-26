import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

import '../controllers/history_balance_controller.dart';

class HistoryBalanceView extends GetView<HistoryBalanceController> {
  const HistoryBalanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Saldo",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      body: Stack(
        children: [
          if (controller.transactionList.isEmpty) ...[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ],
          if (controller.transactionList.isNotEmpty) ...[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0XFFCDE2F8)),
            ),
          ],
          RefreshIndicator(
            color: controller.themeColorServices.primaryBlue.value,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.transactionList.isEmpty) ...[
                    SizedBox(height: 246),
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/img_transaction_not_found.svg",
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Transaksimu Masih Kosong",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Mulai transaksi sekarang dan nikmati proses yang praktis!",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (controller.transactionList.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            "08 Febuary 2025",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.HISTORY_BALANCE_DETAIL);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_wallet.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Topup Saldo",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        Spacer(),
                                        SizedBox(width: 8),
                                        Text(
                                          "Rp55.000",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 6,
                                              height: 12,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.HISTORY_BALANCE_DETAIL);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_wallet.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Topup Saldo",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        Spacer(),
                                        SizedBox(width: 8),
                                        Text(
                                          "Rp55.000",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 6,
                                              height: 12,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            "07 Febuary 2025",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.HISTORY_BALANCE_DETAIL);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_ride.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Antar ke Jatiasih",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        Spacer(),
                                        SizedBox(width: 8),
                                        Text(
                                          "-Rp55.000",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 6,
                                              height: 12,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            "06 Febuary 2025",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.HISTORY_BALANCE_DETAIL);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_ride.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Antar ke Jatimakmur",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        Spacer(),
                                        SizedBox(width: 8),
                                        Text(
                                          "-Rp55.000",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/icon_arrow_right.svg",
                                              width: 6,
                                              height: 12,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
