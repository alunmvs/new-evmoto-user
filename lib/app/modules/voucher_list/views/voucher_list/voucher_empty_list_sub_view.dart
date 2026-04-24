import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/controllers/voucher_list_controller.dart';

class VoucherEmptyListSubView extends GetView<VoucherListController> {
  const VoucherEmptyListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 47 + 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/img_voucher_not_found.png",
                width: MediaQuery.of(context).size.width * 317 / 375,
              ),
            ),
            SizedBox(height: 18),
            Container(
              width: MediaQuery.of(context).size.width * 309 / 375,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                controller.selectedIndex.value == 1
                    ? (controller
                              .languageServices
                              .language
                              .value
                              .promoVoucherNotAvailable ??
                          "-")
                    : (controller
                              .languageServices
                              .language
                              .value
                              .unavailablePromoVoucherNotAvailable ??
                          "-"),
                style: controller.typographyServices.bodyLargeBold.value,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 309 / 375,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                controller.selectedIndex.value == 1
                    ? (controller
                              .languageServices
                              .language
                              .value
                              .noHaveAnyPromo ??
                          "-")
                    : (controller
                              .languageServices
                              .language
                              .value
                              .unavailableNoHaveAnyPromo ??
                          "-"),
                style: controller.typographyServices.bodySmallRegular.value,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
