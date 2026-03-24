import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/voucher_list_controller.dart';

class VoucherListView extends GetView<VoucherListController> {
  const VoucherListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.promoVoucher ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 57,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        controller.selectedIndex.value = 1;
                        await controller.getVoucherList();
                      },
                      child: Container(
                        height: 33,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: controller.selectedIndex.value == 1 ? 2 : 1,
                            color: controller.selectedIndex.value == 1
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .voucherAvailable ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  fontWeight:
                                      controller.selectedIndex.value == 1
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: controller.selectedIndex.value == 1
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : Color(0XFFB3B3B3),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        controller.selectedIndex.value = 2;
                        await controller.getVoucherList();
                      },
                      child: Container(
                        height: 33,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: controller.selectedIndex.value == 2 ? 2 : 1,
                            color: controller.selectedIndex.value == 2
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .voucherNotAvailable ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  fontWeight:
                                      controller.selectedIndex.value == 2
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: controller.selectedIndex.value == 2
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : Color(0XFFB3B3B3),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              color: controller.themeColorServices.neutralsColorGrey200.value,
            ),
            if (controller.isFetch.value == true) ...[
              Expanded(
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
            if (controller.isFetch.value == false) ...[
              Expanded(
                child: Stack(
                  children: [
                    if (controller.voucherList.isEmpty &&
                        controller.isFetch.value == false) ...[
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
                    ],
                    SmartRefresher(
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
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                        canLoadingIcon: null,
                        loadingIcon: null,
                        idleIcon: null,
                        noMoreIcon: null,
                        failedIcon: null,
                      ),
                      enablePullDown: true,
                      enablePullUp: controller.isSeeMoreVoucherList.value,
                      onRefresh: () async {
                        await controller.getVoucherList();
                        controller.refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        await controller.seeMoreVoucherList();
                        controller.refreshController.loadComplete();
                      },
                      controller: controller.refreshController,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.isFetch.value == false) ...[
                                if (controller.voucherList.isEmpty) ...[
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 47 + 16),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.asset(
                                            "assets/images/img_voucher_not_found.png",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                317 /
                                                375,
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              309 /
                                              375,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .promoVoucherNotAvailable ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodyLargeBold
                                                .value,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              309 /
                                              375,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .noHaveAnyPromo ??
                                                "-",
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
                                ],
                                if (controller.voucherList.isNotEmpty) ...[
                                  SizedBox(height: 12),
                                  for (var voucher
                                      in controller.voucherList) ...[
                                    if (controller.selectedIndex.value ==
                                        1) ...[
                                      Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0XFFD7D7D7),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp',
                                                          decimalDigits: 0,
                                                        ).format(voucher.money),
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value,
                                                      ),
                                                      if (voucher.fullMoney !=
                                                              0 &&
                                                          voucher.fullMoney !=
                                                              null) ...[
                                                        SizedBox(width: 2),
                                                        Expanded(
                                                          child: Text(
                                                            "${controller.languageServices.language.value.minOrder ?? "-"} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(voucher.fullMoney)}",
                                                            style: controller
                                                                .typographyServices
                                                                .captionLargeRegular
                                                                .value
                                                                .copyWith(
                                                                  color: Color(
                                                                    0XFFEB5757,
                                                                  ),
                                                                ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                    Get.find<HomeController>()
                                                            .indexNavigationBar
                                                            .value =
                                                        0;
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      color: controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                    ),
                                                    child: Text(
                                                      controller
                                                              .languageServices
                                                              .language
                                                              .value
                                                              .use ??
                                                          "-",
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value
                                                          .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Divider(
                                              height: 0,
                                              color: Color(0XFFEAEAEA),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/icon_calendar.svg',
                                                        width: 12,
                                                        height: 13.88,
                                                        color: Color(
                                                          0XFF828282,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    "${controller.languageServices.language.value.validUntil ?? "-"} ${voucher.time}",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0XFF828282,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (controller.selectedIndex.value ==
                                        2) ...[
                                      Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0XFFD7D7D7),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: 'Rp',
                                                          decimalDigits: 0,
                                                        ).format(voucher.money),
                                                        style: controller
                                                            .typographyServices
                                                            .bodyLargeBold
                                                            .value
                                                            .copyWith(
                                                              color: Color(
                                                                0XFF939393,
                                                              ),
                                                            ),
                                                      ),
                                                      if (voucher.fullMoney !=
                                                              0 &&
                                                          voucher.fullMoney !=
                                                              null) ...[
                                                        SizedBox(width: 2),
                                                        Expanded(
                                                          child: Text(
                                                            "${controller.languageServices.language.value.minOrder ?? "-"} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(voucher.fullMoney)}",
                                                            style: controller
                                                                .typographyServices
                                                                .captionLargeRegular
                                                                .value
                                                                .copyWith(
                                                                  color: Color(
                                                                    0XFF939393,
                                                                  ),
                                                                ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: Color(0XFFEEEEEE),
                                                  ),
                                                  child: Text(
                                                    voucher.couponStatus ==
                                                            "expired"
                                                        ? (controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .expired ??
                                                              "-")
                                                        : (controller
                                                                  .languageServices
                                                                  .language
                                                                  .value
                                                                  .used ??
                                                              "-"),
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: Color(
                                                            0XFF9E9E9E,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Divider(
                                              height: 0,
                                              color: Color(0XFFEAEAEA),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/icon_calendar.svg',
                                                        width: 12,
                                                        height: 13.88,
                                                        color: Color(
                                                          0XFFB3B3B3,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    "${controller.languageServices.language.value.validUntil ?? "-"} ${voucher.time}",
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0XFFB3B3B3,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 12),
                                  ],
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
