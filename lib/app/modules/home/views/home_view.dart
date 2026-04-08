import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_active_order_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_advertisement_list_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_app_bar_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_bottom_navigation_bar_subview.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_map_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_shortcut_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (Platform.isAndroid) {
            var now = DateTime.now();

            if (now.difference(controller.lastPressedBackDateTime.value) >
                Duration(seconds: 2)) {
              controller.lastPressedBackDateTime.value = now;
            } else {
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
          appBar: HomeAppBarSubView(),
          backgroundColor: controller.indexNavigationBar.value == 0
              ? controller.themeColorServices.neutralsColorGrey0.value
              : controller.themeColorServices.primaryBlue.value,
          extendBodyBehindAppBar: controller.indexNavigationBar.value == 0
              ? true
              : false,
          body: IndexedStack(
            index: controller.indexNavigationBar.value,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GlobalBodyHandler(
                  isFetch: false,
                  isCriticalError: controller.isCriticalError.value,
                  onInit: () async {
                    await controller.onInit();
                  },
                  body: Stack(
                    children: [
                      HomeMapSubView(),
                      SlidingUpPanel(
                        padding: EdgeInsets.all(0),
                        minHeight:
                            MediaQuery.of(context).size.height -
                            (25 +
                                MediaQuery.of(context).size.width /
                                    (375 / 369)),
                        maxHeight:
                            MediaQuery.of(context).size.height -
                            (25 +
                                MediaQuery.of(context).size.width /
                                    (375 / 369)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.transparent,
                        boxShadow: null,
                        panelBuilder: (sc) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await controller
                                            .moveGoogleMapCameraToCurrentLocation();
                                      },
                                      child: Container(
                                        width: 41,
                                        height: 41,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            99999999,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: controller
                                                  .themeColorServices
                                                  .overlayDark200
                                                  .value
                                                  .withValues(alpha: 0.12),
                                              blurRadius: 16,
                                              spreadRadius: 2,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_current_location.svg",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      physics: ClampingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          HomeShortcutSubView(),
                                          SizedBox(height: 16),
                                          HomeAdvertisementListSubView(),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      HomeActiveOrderSubView(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ActivityView(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: AccountView(),
              ),
            ],
          ),
          bottomNavigationBar: HomeBottomNavigationBarSubview(),
        ),
      ),
    );
  }
}
