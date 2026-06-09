import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/driver_cancel_dialog.dart';

class AccountUserInfoSubView extends GetView<AccountController> {
  const AccountUserInfoSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 11.5, horizontal: 16),
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey200.value,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (controller.homeController.userServices.userInfo.value.avatar ==
                    "" ||
                controller.homeController.userServices.userInfo.value.avatar ==
                    null) ...[
              SvgPicture.asset(
                "assets/icons/icon_profile_filled.svg",
                width: 48,
                height: 48,
              ),
            ],
            if (controller.homeController.userServices.userInfo.value.avatar !=
                    "" &&
                controller.homeController.userServices.userInfo.value.avatar !=
                    null) ...[
              CircleAvatar(
                backgroundColor:
                    controller.themeColorServices.neutralsColorGrey0.value,
                radius: 48 / 2,
                backgroundImage: CachedNetworkImageProvider(
                  controller.homeController.userServices.userInfo.value.avatar!,
                ),
              ),
            ],
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.homeController.userServices.userInfo.value.name ??
                      "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
                Text(
                  "+${controller.homeController.userServices.userInfo.value.phone ?? "-"}",
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey500
                            .value,
                      ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.ADD_EDIT_USER_INFORMATION);
                // Get.toNamed(
                //   Routes.RIDE_CALL_SENDBIRD,
                //   arguments: {
                //     'is_caller': true,
                //     'driver_id': "dashboard_testing",
                //     'driver_name': "Testing dashboard",
                //     'driver_avatar_url': "",
                //   },
                // );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      controller.themeColorServices.sematicColorBlue100.value,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  "assets/icons/icon_edit.svg",
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    controller.themeColorServices.sematicColorBlue500.value,
                    BlendMode.srcIn,
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
