import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/ride_checkout_select_payment_method_controller.dart';

class RideCheckoutSelectPaymentMethodView
    extends GetView<RideCheckoutSelectPaymentMethodController> {
  const RideCheckoutSelectPaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Metode Pembayaran",
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
            : RadioGroup(
                onChanged: (value) {
                  if (value != null) {
                    controller.selectPayType(value);
                  }
                },
                groupValue: controller.selectedPayType.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 6, color: Color(0XFFF2F2F2), thickness: 6),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Pilih Metode Pembayaran",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (controller.isCashEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildCashOption(),
                      ),
                      SizedBox(height: 16),
                    ],
                    if (controller.isGopayEnabled &&
                        !controller.isGopayLinked) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildGopayInactiveOption(),
                      ),
                      SizedBox(height: 16),
                    ],
                    if (controller.isGopayEnabled &&
                        controller.isGopayLinked) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildGopayActiveOption(),
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCashOption() {
    final payType = RideCheckoutSelectPaymentMethodController.payTypeCash;
    final isSelected = controller.selectedPayType.value == payType;

    return GestureDetector(
      onTap: () => controller.selectPayType(payType),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0XFFEDF6FF) : Color(0XFFFFFFFF),
          border: Border.all(
            color: isSelected ? Color(0XFF7AC0F8) : Color(0XFFD9D9D9),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/icon_payment_method_cash.png",
                width: 23,
                height: 19,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cash",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Pembayaran praktis dan cepat",
                      style: controller.typographyServices.bodySmallRegular.value
                          .copyWith(color: Color(0XFFB3B3B3)),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Radio(
                    value: payType,
                    activeColor:
                        controller.themeColorServices.primaryBlue.value,
                    backgroundColor: isSelected
                        ? WidgetStateProperty.all(
                            controller
                                .themeColorServices
                                .sematicColorBlue100
                                .value,
                          )
                        : WidgetStateProperty.all(
                            controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGopayInactiveOption() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        border: Border.all(color: Color(0XFFD9D9D9), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/icon_payment_method_gopay.png",
              width: 24,
              height: 24,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GoPay",
                    style: controller.typographyServices.bodySmallBold.value,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Silahkan aktifkan layanan ini",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(color: Color(0XFFB3B3B3)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              height: 36,
              child: LoaderElevatedButton(
                buttonColor: Color(0XFF009756),
                borderRadius: BorderRadius.circular(6),
                child: Text(
                  "Aktifkan",
                  style: controller.typographyServices.bodySmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
                onPressed: () async {
                  await controller.onTapActivateGopay();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGopayActiveOption() {
    final payType = RideCheckoutSelectPaymentMethodController.payTypeGopay;
    final isSelected = controller.selectedPayType.value == payType;
    final formattedBalance = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(controller.gopayBalance.value.balance ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFE1FDE5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.selectPayType(payType),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Color(0XFFEDF6FF) : Color(0XFFFFFFFF),
                border: Border.all(
                  color: isSelected ? Color(0XFF7AC0F8) : Color(0XFFD9D9D9),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/icon_payment_method_gopay.png",
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "GoPay",
                            style:
                                controller.typographyServices.bodySmallBold.value,
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Transaksi lebih nyaman dengan GoPay",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Saldo: $formattedBalance",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: Color(0XFF0060C6),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Radio(
                          value: payType,
                          activeColor:
                              controller.themeColorServices.primaryBlue.value,
                          backgroundColor: isSelected
                              ? WidgetStateProperty.all(
                                  controller
                                      .themeColorServices
                                      .sematicColorBlue100
                                      .value,
                                )
                              : WidgetStateProperty.all(
                                  controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.add, size: 9.1 * 2, color: Color(0XFF02512F)),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Top up GoPay",
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF02512F),
                        ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/icons/icon_arrow_right.svg",
                  width: 6,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    Color(0XFF02512F),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
