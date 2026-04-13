import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/controllers/ride_order_done_controller.dart';

class RideOrderDoneInvoiceSubView extends GetView<RideOrderDoneController> {
  const RideOrderDoneInvoiceSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: controller.themeColorServices.neutralsColorGrey0.value,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.themeColorServices.neutralsColorGrey200.value,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(controller.orderRideDetail.value.payMoney),
                style: controller.typographyServices.headingLargeBold.value
                    .copyWith(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Text(
                controller
                        .languageServices
                        .language
                        .value
                        .pleaseMakePaymentAccording ??
                    "-",
                style: controller.typographyServices.bodySmallRegular.value
                    .copyWith(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey600
                          .value,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: controller.themeColorServices.neutralsColorGrey0.value,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.themeColorServices.neutralsColorGrey200.value,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.languageServices.language.value.travelExpense ??
                        "-",
                    style: controller.typographyServices.bodySmallRegular.value
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
                    ).format(controller.getTravelFare()),
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                  ),
                ],
              ),
              if (controller.orderRideDetail.value.additionalCharge != 0) ...[
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .additionalCost ??
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
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp',
                        decimalDigits: 0,
                      ).format(
                        controller.orderRideDetail.value.additionalCharge,
                      ),
                      style: controller.typographyServices.bodySmallBold.value
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
              if (controller.getPromoMoney() != 0) ...[
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.languageServices.language.value.promotion ??
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
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: '-Rp',
                        decimalDigits: 0,
                      ).format(controller.getPromoMoney()),
                      style: controller.typographyServices.bodySmallBold.value
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
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.languageServices.language.value.total ?? "-",
                    style: controller.typographyServices.bodySmallBold.value
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
                    ).format(controller.orderRideDetail.value.payMoney),
                    style: controller.typographyServices.bodySmallBold.value
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
    );
  }
}
