import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/account_payment_method_gopay_detail_controller.dart';

class AccountPaymentMethodGopayDetailView
    extends GetView<AccountPaymentMethodGopayDetailController> {
  const AccountPaymentMethodGopayDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Pengaturan Pembayaran",
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
                      "Detail GoPay",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0XFFE5E5E5)),
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
                            SizedBox(width: 8),
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
                                  SizedBox(height: 4),
                                  Text(
                                    "Saldo: ${controller.balance.value}",
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
                            Center(
                              child: Text(
                                "Terhubung",
                                style: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFF01AC63)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0XFFE5E5E5)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nomor Akun",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey500
                                            .value,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.accountNumber.value,
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await controller.onTapCopyAccountNumber();
                            },
                            child: Icon(
                              Icons.copy_outlined,
                              size: 20,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey600
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Pengaturan",
                      style:
                          controller.typographyServices.bodySmallRegular.value,
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        await controller.onTapSetAsMainMethod();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0XFFE5E5E5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Atur menjadi metode utama",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icons/icon_arrow_right.svg",
                              width: 6,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapCancelPaymentMethod();
                },
                buttonColor: controller.themeColorServices.redColor.value,
                child: Text(
                  "Batalkan metode pembayaran",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
