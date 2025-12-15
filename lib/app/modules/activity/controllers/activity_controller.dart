import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/active_order_model.dart';
import 'package:new_evmoto_user/app/data/history_order_model.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRideRepository orderRideRepository;

  ActivityController({required this.orderRideRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  late TabController tabController;
  final indexTabBar = 0.obs;

  final latestActivityList = [1, 2].obs;
  final historyActivityList = [1, 2].obs;

  final activeOrderList = <ActiveOrder>[].obs;
  final historyOrderList = <HistoryOrder>[].obs;
  final historyOrderPageNum = 1.obs;
  final historyOrderSize = 20.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      indexTabBar.value = tabController.index;
    });

    await Future.wait([getActiveOrderList(), getHistoryOrderList()]);

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getActiveOrderList() async {
    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));

    for (var activeOrder in activeOrderList) {
      activeOrder.orderRideModel = await orderRideRepository
          .getOrderRideDetailbyOrderId(
            orderId: activeOrder.orderId.toString(),
            orderType: activeOrder.orderType,
            language: languageServices.languageCodeSystem.value,
          );
    }

    activeOrderList.refresh();
  }

  Future<void> getHistoryOrderList() async {
    historyOrderList.value = (await orderRideRepository.getHistoryOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: historyOrderPageNum.value,
      size: historyOrderSize.value,
      type: 1,
    ));
  }

  String getStatusActivityByState({required int state}) {
    switch (state) {
      case 1:
        return 'Pencarian Driver Evmoto';
      case 2:
        return 'Driver Menerima Pesanan';
      case 3:
        return 'Driver Berangkat ke Lokasi Penjemputan';
      case 4:
        return 'Driver Sampai di Lokasi Penjemputan';
      default:
        return '-';
    }
  }
}
