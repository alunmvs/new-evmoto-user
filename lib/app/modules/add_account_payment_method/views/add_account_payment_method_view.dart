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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "Dompet Digital",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/icon_payment_method_gopay.png",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "GoPay",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
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
