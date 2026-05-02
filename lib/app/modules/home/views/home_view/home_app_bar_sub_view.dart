import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class HomeAppBarSubView extends GetView<HomeController>
    implements PreferredSizeWidget {
  const HomeAppBarSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        title: Column(
          children: [
            if (controller.indexNavigationBar.value == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .helloWhereToday ??
                              "-",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          controller.userServices.userInfo.value.name ?? "-",
                          style: controller
                              .typographyServices
                              .headingSmallBold
                              .value
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Get.toNamed(Routes.CHAT_LIST);
                      await controller.refreshAll();
                    },
                    child: Badge(
                      isLabelVisible:
                          controller.isSendbirdInit.value == false ||
                          controller.totalUnreadMessageCount.value > 0,
                      label: controller.isSendbirdInit.value == false
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 8,
                            )
                          : Text(
                              controller.totalUnreadMessageCount.value > 99
                                  ? "99+"
                                  : controller.totalUnreadMessageCount.value
                                        .toString(),
                              style: controller
                                  .typographyServices
                                  .captionSmallRegular
                                  .value,
                            ),
                      backgroundColor: Color(0XFF17CC8C),
                      child: SizedBox(
                        width: 26.73,
                        height: 26.73,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/icon_chat.svg',
                              width: 23.34,
                              height: 23.34,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: controller.totalUnreadMessageCount.value > 0 ? 8 : 0,
                  ),
                ],
              ),
            ],
            if (controller.indexNavigationBar.value == 1) ...[
              Text(
                controller.languageServices.language.value.activity ?? "-",
                style: controller.typographyServices.headingSmallBold.value
                    .copyWith(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                    ),
              ),
            ],
            if (controller.indexNavigationBar.value == 2) ...[
              Text(
                controller.languageServices.language.value.account ?? "-",
                style: controller.typographyServices.headingSmallBold.value
                    .copyWith(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                    ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        backgroundColor: controller.themeColorServices.primaryBlue.value,
        toolbarHeight: controller.indexNavigationBar.value == 0 ? 80 : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
