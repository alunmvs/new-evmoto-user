import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';

import '../../../../routes/app_pages.dart';

class AccountMenuSection1SubView extends GetView<AccountController> {
  const AccountMenuSection1SubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey200.value,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.SETTING_LANGUAGE);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_language.svg",
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .settingLanguage ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        if (controller.languageServices.languageCode.value ==
                            "ZH_CN") ...[
                          SvgPicture.asset(
                            "assets/icons/icon_flag_cn.svg",
                            width: 16,
                            height: 16,
                          ),
                        ],
                        if (controller.languageServices.languageCode.value ==
                            "EN") ...[
                          SvgPicture.asset(
                            "assets/icons/icon_flag_en.svg",
                            width: 16,
                            height: 16,
                          ),
                        ],
                        if (controller.languageServices.languageCode.value ==
                            "ID") ...[
                          SvgPicture.asset(
                            "assets/icons/icon_flag_id.svg",
                            width: 16,
                            height: 16,
                          ),
                        ],

                        SizedBox(width: 13),
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.VOUCHER_LIST);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_voucher-1.svg",
                            width: 13.33,
                            height: 10.67,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller.languageServices.language.value.myVoucher ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.SETTING_SAVED_LOCATION);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .sematicColorBlue100
                            .value,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_save.svg",
                            width: 12.2,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorBlue500
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .settingSavedLocation ??
                          "-",
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_arrow_right.svg",
                          width: 6,
                          height: 12,
                        ),
                      ],
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
