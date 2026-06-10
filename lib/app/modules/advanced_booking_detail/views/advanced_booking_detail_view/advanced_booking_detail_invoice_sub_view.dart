import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';

class AdvancedBookingDetailInvoiceSubView
    extends GetView<AdvancedBookingDetailController> {
  const AdvancedBookingDetailInvoiceSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isFetch.value
          ? Container()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      controller.themeColorServices.neutralsColorGrey200.value,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.orderRideDetail.value.orderId != null) ...[
                    if (controller.orderRideDetail.value.state != 10) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .travelExpense ??
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
                            ).format(controller.getTravelFare()),
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
                      if (controller.orderRideDetail.value.additionalCharge !=
                          0) ...[
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
                                controller
                                        .orderRideDetail
                                        .value
                                        .additionalCharge ??
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
                      if (controller.getPromoMoney() != 0) ...[
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .promotion ??
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
                      SizedBox(height: 12),
                    ],
                    if (controller.orderRideDetail.value.state != 10) ...[
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .waitingTimeFeeTitle ??
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
                              if ((controller.orderRideDetail.value.waitMoney ??
                                      0.0) >
                                  0) ...[
                                Text(
                                  (controller
                                              .languageServices
                                              .language
                                              .value
                                              .waitingTimeFeeDescription ??
                                          "-")
                                      .replaceAll(
                                        "{time}",
                                        "${(controller.orderRideDetail.value.wait ?? 0.0).round()} ${controller.languageServices.language.value.minute}",
                                      ),
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFFB3B3B3)),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(
                              controller.orderRideDetail.value.waitMoney,
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
                  ],
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
                      if (controller.advancedBooking.value.payType == 2) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_wallet.svg",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .evmotoBalance ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ],
                        ),
                      ],
                      if (controller.advancedBooking.value.payType == 3) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_cash.svg",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              controller.languageServices.language.value.cash ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.orderRideDetail.value.orderId == null
                            ? "Estimasi Harga"
                            : controller
                                      .languageServices
                                      .language
                                      .value
                                      .total ??
                                  "-",
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
                        ).format(
                          controller.orderRideDetail.value.orderId == null
                              ? controller.advancedBooking.value.orderMoney
                              : controller.orderRideDetail.value.state == 10
                              ? 0
                              : (controller.orderRideDetail.value.payMoney ??
                                    0.0),
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
              ),
            ),
    );
  }
}
