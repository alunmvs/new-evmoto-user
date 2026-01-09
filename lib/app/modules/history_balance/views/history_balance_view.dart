import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/balance_history_consumption_model.dart';
import 'package:new_evmoto_user/app/data/models/balance_history_deposit_model.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/history_balance_controller.dart';

class HistoryBalanceView extends GetView<HistoryBalanceController> {
  const HistoryBalanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.balanceHistory ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
            : Stack(
                children: [
                  if (controller
                      .sortedBalanceHistoryListByDate
                      .keys
                      .isEmpty) ...[
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
                  if (controller
                      .sortedBalanceHistoryListByDate
                      .keys
                      .isNotEmpty) ...[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ],
                  SmartRefresher(
                    header: MaterialClassicHeader(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                    footer: ClassicFooter(
                      loadStyle: LoadStyle.HideAlways,
                      textStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                      canLoadingIcon: null,
                      loadingIcon: null,
                      idleIcon: null,
                      noMoreIcon: null,
                      failedIcon: null,
                    ),
                    enablePullDown: true,
                    enablePullUp:
                        controller.balanceHistoryConsumptionSeeMore.value &&
                        controller.balanceHistoryDepositSeeMore.value,
                    onRefresh: () async {
                      await controller.refreshAll();
                      controller.refreshController.refreshCompleted();
                    },
                    onLoading: () async {
                      await controller.seeMoreAll();
                      controller.refreshController.loadComplete();
                    },
                    controller: controller.refreshController,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller
                              .sortedBalanceHistoryListByDate
                              .keys
                              .isEmpty) ...[
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
                          if (controller
                              .sortedBalanceHistoryListByDate
                              .keys
                              .isNotEmpty) ...[
                            for (var createDate
                                in controller
                                    .sortedBalanceHistoryListByDate
                                    .keys) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    child: Text(
                                      DateFormat(
                                        'dd MMMM yyyy',
                                        controller
                                            .languageServices
                                            .languageCode
                                            .value,
                                      ).format(createDate),
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var balanceHistory
                                              in controller
                                                  .sortedBalanceHistoryListByDate[createDate]) ...[
                                            if (balanceHistory
                                                is BalanceHistoryDeposit) ...[
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes
                                                        .HISTORY_BALANCE_DETAIL,
                                                    arguments: {
                                                      "balance_history_deposit":
                                                          balanceHistory,
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 16,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
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
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                              balanceHistory
                                                                      .createTime ??
                                                                  "-",
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
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          balanceHistory
                                                                  .amount ??
                                                              0.0,
                                                        ),
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
                                              if (controller
                                                      .sortedBalanceHistoryListByDate[createDate]
                                                      .last !=
                                                  balanceHistory) ...[
                                                Divider(
                                                  height: 0,
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                              ],
                                            ],
                                            if (balanceHistory
                                                is BalanceHistoryConsumption) ...[
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes
                                                        .HISTORY_BALANCE_DETAIL,
                                                    arguments: {
                                                      "balance_history_consumption":
                                                          balanceHistory,
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 16,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
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
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              balanceHistory
                                                                          .type ==
                                                                      1
                                                                  ? controller
                                                                            .languageServices
                                                                            .language
                                                                            .value
                                                                            .deliveryService ??
                                                                        "-"
                                                                  : "-",
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
                                                              balanceHistory
                                                                      .createTime ??
                                                                  "-",
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
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: '-Rp',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          balanceHistory
                                                                  .money ??
                                                              0.0,
                                                        ),
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
                                              if (controller
                                                      .sortedBalanceHistoryListByDate[createDate]
                                                      .last !=
                                                  balanceHistory) ...[
                                                Divider(
                                                  height: 0,
                                                  color: controller
                                                      .themeColorServices
                                                      .neutralsColorGrey200
                                                      .value,
                                                ),
                                              ],
                                            ],
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
