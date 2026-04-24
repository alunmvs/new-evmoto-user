import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/views/voucher_list/voucher_available_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/views/voucher_list/voucher_empty_list_sub_view.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/views/voucher_list/voucher_list_tab_bar_sub_view.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/views/voucher_list/voucher_not_available_card_sub_view.dart';
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
            VoucherListTabBarSubView(),
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
                                  VoucherEmptyListSubView(),
                                ],
                                if (controller.voucherList.isNotEmpty) ...[
                                  SizedBox(height: 12),
                                  for (var voucher
                                      in controller.voucherList) ...[
                                    if (controller.selectedIndex.value ==
                                        1) ...[
                                      VoucherAvailableCardSubView(
                                        voucher: voucher,
                                      ),
                                    ],
                                    if (controller.selectedIndex.value ==
                                        2) ...[
                                      VoucherNotAvailableCardSubView(
                                        voucher: voucher,
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
