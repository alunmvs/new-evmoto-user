import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBottomNavigationBarSubview extends GetView<HomeController> {
  const HomeBottomNavigationBarSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Divider(
            height: 0,
            color: controller.themeColorServices.neutralsColorGrey100.value,
            thickness: 2,
          ),
          NavigationBar(
            height: 64,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            selectedIndex: controller.indexNavigationBar.value,
            onDestinationSelected: (value) {
              controller.indexNavigationBar.value = value;
            },
            destinations: [
              GestureDetector(
                onTap: () async {
                  controller.indexNavigationBar.value = 0;
                  await controller.refreshAll();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 28.5 / 2,
                        ),
                        child: Divider(
                          height: 0,
                          color: controller.indexNavigationBar.value == 0
                              ? controller.themeColorServices.primaryBlue.value
                              : Colors.transparent,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 9),
                      SvgPicture.asset(
                        "assets/icons/icon_home.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          controller.indexNavigationBar.value == 0
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.languageServices.language.value.home ?? "-",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color: controller.indexNavigationBar.value == 0
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
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  controller.indexNavigationBar.value = 1;
                  var prefs = await SharedPreferences.getInstance();

                  if (prefs.getBool('activity_controller_registered') == true) {
                    await Get.find<ActivityController>().refreshAll();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28.5 / 2,
                          right: 28.5 / 2,
                        ),
                        child: Divider(
                          height: 0,
                          color: controller.indexNavigationBar.value == 1
                              ? controller.themeColorServices.primaryBlue.value
                              : Colors.transparent,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 8),
                      SvgPicture.asset(
                        "assets/icons/icon_activity.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          controller.indexNavigationBar.value == 1
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.languageServices.language.value.activity ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color: controller.indexNavigationBar.value == 1
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
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  controller.indexNavigationBar.value = 2;
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28.5 / 2,
                          right: 24,
                        ),
                        child: Divider(
                          height: 0,
                          color: controller.indexNavigationBar.value == 2
                              ? controller.themeColorServices.primaryBlue.value
                              : Colors.transparent,
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 8),
                      SvgPicture.asset(
                        "assets/icons/icon_account.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          controller.indexNavigationBar.value == 2
                              ? controller.themeColorServices.primaryBlue.value
                              : controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.languageServices.language.value.account ??
                            "-",
                        style: controller
                            .typographyServices
                            .captionLargeBold
                            .value
                            .copyWith(
                              color: controller.indexNavigationBar.value == 2
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
