import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/voucher_detail_controller.dart';

class VoucherDetailView extends GetView<VoucherDetailController> {
  const VoucherDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.voucherDetail ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor:
            controller.themeColorServices.neutralsColorSlate100.value,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            AspectRatio(
              aspectRatio: 375 / 187,
              child: Image.asset(
                "assets/images/img_promo_1.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            RefreshIndicator(
              color: controller.themeColorServices.primaryBlue.value,
              backgroundColor:
                  controller.themeColorServices.neutralsColorGrey0.value,
              onRefresh: () async {},
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height:
                            ((MediaQuery.of(context).size.width * 187) / 375) -
                            16,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: controller
                                  .themeColorServices
                                  .overlayDark100
                                  .value
                                  .withValues(alpha: 0.1),
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.couponDetail.value.name ?? "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey700
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Berakhir pada : ${controller.couponDetail.value.time}",
                              style: controller
                                  .typographyServices
                                  .captionLargeRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorSlate300
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 14),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0XFFFFFFFF),
                                            Color(0XFFCDE2F8),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 24 - 8),
                                          Center(
                                            child: Text(
                                              controller
                                                          .couponDetail
                                                          .value
                                                          .type ==
                                                      1
                                                  ? "Tidak Ada Minimal Transaksi"
                                                  : "Minimal Transaksi ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(controller.couponDetail.value.fullMoney)}",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue600
                                                        .value,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_voucher.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "EVMOTOPROMO2025",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: controller
                                  .themeColorServices
                                  .overlayDark100
                                  .value
                                  .withValues(alpha: 0.1),
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.isOpenTermAndCondition.value =
                                    !controller.isOpenTermAndCondition.value;
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Syarat Dan Ketentuan",
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
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                controller
                                                        .isOpenTermAndCondition
                                                        .value
                                                    ? "assets/icons/icon_arrow_up.svg"
                                                    : "assets/icons/icon_arrow_down.svg",
                                                width: 13,
                                                height: 7.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.isOpenTermAndCondition.value) ...[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    Text(
                                      "1. Pengguna wajib memiliki akun terdaftar dan memberikan informasi yang akurat serta terkini.\n2. Layanan hanya dapat digunakan sesuai dengan ketentuan hukum yang berlaku.\n3. Perusahaan berhak mengubah menangguhkan, atau menghentikan layanan tanpa pemberitahuan sebelumnya.\n4. Pengguna bertanggung jawab penuh atas keamanan akun dan aktivitas yang terjadi di dalamnya.\n5. Data pribadi pengguna akan dikelola sesuai dengan kebijakan privasi yang berlaku.\n6. Perusahaan tidak bertanggung jawab atas kerugian akibat penyalahgunaan layanan oleh pihak ketiga.\n8. Pelanggaran terhadap ketentuan ini dapat mengakibatkan pembatasan akses atau penghentian layanan.\n9. Pengguna tidak diperbolehkan menyebarkan konten yang melanggar hukum atau merugikan pihak lain.\n10. Semua transaksi yang dilakukan melalui layanan ini bersifat final dan tidak dapat dibatalkan, kecuali dinyatakan lain.\n11. Dengan menggunakan layanan ini, pengguna dianggap telah membaca dan menyetujui semua syarat serta ketentuan yang berlaku.",
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: controller
                                  .themeColorServices
                                  .overlayDark100
                                  .value
                                  .withValues(alpha: 0.1),
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Informasi Lainnya",
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
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_down.svg",
                                                width: 13,
                                                height: 7.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: controller
                                  .themeColorServices
                                  .overlayDark100
                                  .value
                                  .withValues(alpha: 0.1),
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Cara Menggunakan",
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
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_down.svg",
                                                width: 13,
                                                height: 7.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            controller.isFetch.value || controller.isSelectCoupon.value == false
            ? null
            : BottomAppBar(
                height: 78,
                padding: EdgeInsets.all(16),
                color: controller.themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 46,
                      width: MediaQuery.of(context).size.width,
                      child: LoaderElevatedButton(
                        onPressed: () async {
                          Get.back();
                          Get.back(result: controller.couponDetail.value);
                        },
                        buttonColor:
                            controller.themeColorServices.primaryBlue.value,
                        child: Text(
                          controller.languageServices.language.value.usePromo ??
                              "-",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Colors.white),
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
