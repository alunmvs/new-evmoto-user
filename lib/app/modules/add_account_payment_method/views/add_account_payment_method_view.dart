import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/add_account_payment_method_controller.dart';

class AddAccountPaymentMethodView
    extends GetView<AddAccountPaymentMethodController> {
  const AddAccountPaymentMethodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Metode Lainnya",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Stack(
          children: [
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
            if (controller.isFetch.value)
              Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            else if (controller.isGopayLinked)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/img_payment_method_empty.png",
                        width: 86,
                        height: 86,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran Belum Tersedia",
                        style:
                            controller.typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 297 / 375,
                        child: Text(
                          "Nantikan berbagai pilihan metode pembayaran untuk mendukung transaksi yang lebih mudah dan praktis.",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Dompet Digital",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value,
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await controller.onTapGopay();
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/icon_payment_method_gopay.png",
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "GoPay",
                                        style: controller
                                            .typographyServices
                                            .bodySmallBold
                                            .value,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.displayPhoneNumber,
                                        style: controller
                                            .typographyServices
                                            .captionLargeRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_arrow_right.svg",
                                      width: 8,
                                      height: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.isLinkingGopay.value)
              Container(
                color: Colors.black.withValues(alpha: 0.1),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
