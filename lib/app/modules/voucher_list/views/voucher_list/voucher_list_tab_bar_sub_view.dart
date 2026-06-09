import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/controllers/voucher_list_controller.dart';

class VoucherListTabBarSubView extends GetView<VoucherListController> {
  const VoucherListTabBarSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
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
                  controller.isFetch.value = true;
                  controller.selectedIndex.value = 1;
                  await controller.getVoucherList();
                  controller.isFetch.value = false;
                },
                child: Container(
                  height: 33,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: controller.selectedIndex.value == 1 ? 2 : 1,
                      color: controller.selectedIndex.value == 1
                          ? controller.themeColorServices.primaryBlue.value
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
                            fontWeight: controller.selectedIndex.value == 1
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
                  controller.isFetch.value = true;
                  controller.selectedIndex.value = 2;
                  await controller.getVoucherList();
                  controller.isFetch.value = false;
                },
                child: Container(
                  height: 33,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: controller.selectedIndex.value == 2 ? 2 : 1,
                      color: controller.selectedIndex.value == 2
                          ? controller.themeColorServices.primaryBlue.value
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
                            fontWeight: controller.selectedIndex.value == 2
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
    );
  }
}
