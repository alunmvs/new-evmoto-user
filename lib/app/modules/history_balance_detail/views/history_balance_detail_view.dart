import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/history_balance_detail_controller.dart';

class HistoryBalanceDetailView extends GetView<HistoryBalanceDetailController> {
  const HistoryBalanceDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.languageServices.language.value.transactionDetails ?? "-",
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
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  if (controller.balanceHistoryConsumption.value.type !=
                      null) ...[
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
                                "assets/icons/icon_ride.svg",
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            controller.balanceHistoryConsumption.value.type == 1
                                ? controller
                                          .languageServices
                                          .language
                                          .value
                                          .deliveryService ??
                                      "-"
                                : "-",
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
                            DateFormat(
                              'dd MMMM yyyy ⬩ HH:mm',
                              controller.languageServices.languageCode.value,
                            ).format(
                              controller
                                  .balanceHistoryConsumption
                                  .value
                                  .createTimeDateTime!,
                            ),
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
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: '-Rp',
                              decimalDigits: 0,
                            ).format(
                              controller
                                      .balanceHistoryConsumption
                                      .value
                                      .money ??
                                  0.0,
                            ),
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
                          controller.balanceHistoryConsumption.value.orderId
                              .toString(),
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
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .paymentMethod ??
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
                              Text(
                                controller
                                            .balanceHistoryConsumption
                                            .value
                                            .payType ==
                                        2
                                    ? "Saldo EVMoto"
                                    : controller
                                              .balanceHistoryConsumption
                                              .value
                                              .payType ==
                                          3
                                    ? controller
                                              .languageServices
                                              .language
                                              .value
                                              .cash ??
                                          "-"
                                    : "-",
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
                                controller
                                            .balanceHistoryConsumption
                                            .value
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
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: '-Rp',
                                  decimalDigits: 0,
                                ).format(
                                  controller
                                          .balanceHistoryConsumption
                                          .value
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
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .total ??
                                    "-",
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
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: '-Rp',
                                  decimalDigits: 0,
                                ).format(
                                  controller
                                          .balanceHistoryConsumption
                                          .value
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (controller.balanceHistoryDeposit.value.createTime !=
                      null) ...[
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
                            DateFormat(
                              'dd MMMM yyyy ⬩ HH:mm',
                              controller.languageServices.languageCode.value,
                            ).format(
                              controller
                                  .balanceHistoryDeposit
                                  .value
                                  .createTimeDateTime!,
                            ),
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
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(
                              controller.balanceHistoryDeposit.value.amount ??
                                  0.0,
                            ),
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
                          controller.balanceHistoryDeposit.value.id.toString(),
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
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                ).format(
                                  controller
                                          .balanceHistoryDeposit
                                          .value
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
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                ).format(
                                  controller
                                          .balanceHistoryDeposit
                                          .value
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
                                          .neutralsColorGrey700
                                          .value,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
