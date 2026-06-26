import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/account_payment_method_controller.dart';

class AccountPaymentMethodView extends GetView<AccountPaymentMethodController> {
  const AccountPaymentMethodView({super.key});
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
            controller.isFetch.value
                ? Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                    ),
                  )
                : SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: () async {
                      await controller.refreshAll();
                      controller.refreshController.refreshCompleted();
                    },
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
                    enablePullUp: false,
                    onLoading: () async {
                      controller.refreshController.loadComplete();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              "Pilih Metode",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Color(0XFFE5E5E5)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/icons/icon_payment_method_cash.png",
                                            width: 23,
                                            height: 19,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Cash",
                                                  style: controller
                                                      .typographyServices
                                                      .bodySmallBold
                                                      .value,
                                                ),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFFE4F0FD),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Metode Utama",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value
                                                        .copyWith(
                                                          color: Color(
                                                            0XFF0060C6,
                                                          ),
                                                        ),
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
                                                  .copyWith(
                                                    color: Color(0XFF01AC63),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (controller.gopayLinkStatus.value.linked ==
                                      true) ...[
                                    Divider(
                                      height: 0,
                                      color: Color(0XFFE5E5E5),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapGopayDetail();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/icons/icon_payment_method_gopay.png",
                                                width: 24,
                                                height: 24,
                                              ),
                                              SizedBox(width: 8),
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
                                                      "Saldo: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(controller.gopayBalance.value.balance ?? 0)}",
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
                                                    SizedBox(height: 4),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0XFFE4F0FD,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "Metode Utama",
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallRegular
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF0060C6,
                                                              ),
                                                            ),
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
                                                      .copyWith(
                                                        color: Color(
                                                          0XFF01AC63,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Center(
                                                child: SvgPicture.asset(
                                                  "assets/icons/icon_arrow_right.svg",
                                                  width: 6,
                                                  height: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  await controller.onTapAddPaymentMethod();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 11.67 * 2,
                                      color: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Tambahkan Metode Lainnya",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
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
                            ),
                          ],
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
