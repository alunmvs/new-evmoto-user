import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  late TabController tabController;
  final indexTabBar = 0.obs;

  final latestActivityList = [1, 2].obs;
  final historyActivityList = [1, 2].obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      indexTabBar.value = tabController.index;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
