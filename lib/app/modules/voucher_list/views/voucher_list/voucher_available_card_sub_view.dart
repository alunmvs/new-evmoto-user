import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/controllers/voucher_list_controller.dart';

class VoucherAvailableCardSubView extends GetView<VoucherListController> {
  final Coupon voucher;
  const VoucherAvailableCardSubView({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0XFFD7D7D7)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        style:
                            controller.typographyServices.bodyLargeBold.value,
                      ),
                      if (voucher.fullMoney != 0 &&
                          voucher.fullMoney != null) ...[
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            "${controller.languageServices.language.value.minOrder ?? "-"} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(voucher.fullMoney)}",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value
                                .copyWith(color: Color(0XFFEB5757)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.find<HomeController>().indexNavigationBar.value = 0;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                    child: Text(
                      controller.languageServices.language.value.use ?? "-",
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 0, color: Color(0XFFEAEAEA)),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/icon_calendar.svg',
                        width: 12,
                        height: 13.88,
                        colorFilter: ColorFilter.mode(
                          Color(0xFF828282),
                          BlendMode.srcIn,
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
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF828282),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
