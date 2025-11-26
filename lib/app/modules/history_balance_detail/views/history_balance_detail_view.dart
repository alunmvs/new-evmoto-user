import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/history_balance_detail_controller.dart';

class HistoryBalanceDetailView extends GetView<HistoryBalanceDetailController> {
  const HistoryBalanceDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Transaksi",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      body: Stack(
        children: [
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
          RefreshIndicator(
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey300
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .sematicColorBlue100
                                  .value,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/img_transaction_not_found.svg",
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Topup Saldo",
                            style: controller
                                .typographyServices
                                .headingSmallBold
                                .value,
                            selectionColor: controller
                                .themeColorServices
                                .neutralsColorGrey700
                                .value,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "08 February 2025 ⬩ 12:54",
                            style: controller
                                .typographyServices
                                .bodyLargeRegular
                                .value,
                            selectionColor: controller
                                .themeColorServices
                                .neutralsColorGrey600
                                .value,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Rp55.000",
                            style: controller
                                .typographyServices
                                .headingLargeBold
                                .value,
                            selectionColor: controller
                                .themeColorServices
                                .neutralsColorGrey700
                                .value,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorSlate100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "9941-10083-4798-NDFR-15",
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
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Text(
                                "Rp55.000",
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
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
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
                              Text(
                                "Rp55.000",
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
