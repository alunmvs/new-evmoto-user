import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 6, color: Color(0XFFF2F2F2), thickness: 6),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Pilih Metode Pembayaran",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(color: Color(0XFFD9D9D9), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cash",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                Text(
                                  "Pembayaran praktis dan cepat",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFFB3B3B3)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio(value: "test"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(color: Color(0XFFD9D9D9), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "GoPay",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                Text(
                                  "Silahkan aktifkan layanan ini",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFFB3B3B3)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio(value: "test"),
                          ),
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
