import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';

class AccountLogoutSubView extends GetView<AccountController> {
  const AccountLogoutSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: () async {
              await controller.onTapManageAccount();
            },
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.transparent,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/icon_logout.svg",
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      controller.themeColorServices.sematicColorRed400.value,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    controller.languageServices.language.value.manageAccount ??
                        "-",
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .sematicColorRed400
                              .value,
                        ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey200
                                .value,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${controller.languageServices.language.value.appVersion ?? "-"} v${controller.packageVersion.value}",
                          style: controller
                              .typographyServices
                              .captionSmallBold
                              .value,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
