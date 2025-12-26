import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRideRepository orderRideRepository;

  ActivityController({required this.orderRideRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final homeController = Get.find<HomeController>();

  late TabController tabController;
  final indexTabBar = 0.obs;

  final latestActivityList = [1, 2].obs;
  final historyActivityList = [1, 2].obs;

  final activeOrderRefreshController = RefreshController();
  final activeOrderList = <ActiveOrder>[].obs;
  final activeOrderPageNum = 1.obs;
  final activeOrderSize = 5.obs;
  final activeOrderSeeMore = true.obs;

  final historyOrderRefreshController = RefreshController();
  final historyOrderList = <HistoryOrder>[].obs;
  final historyOrderPageNum = 1.obs;
  final historyOrderSize = 5.obs;
  final historyOrderSeeMore = true.obs;

  final historyOrderSelectedOrderType = 1.obs;

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

  Future<void> refreshAll() async {
    await Future.wait([getActiveOrderList(), getHistoryOrderList()]);
  }

  Future<void> getActiveOrderList() async {
    activeOrderPageNum.value = 1;
    activeOrderSeeMore.value = true;

    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));

    for (var activeOrder in activeOrderList) {
      activeOrder.orderRide = await orderRideRepository
          .getOrderRideDetailbyOrderId(
            orderId: activeOrder.orderId.toString(),
            orderType: activeOrder.orderType,
            language: languageServices.languageCodeSystem.value,
          );
    }

    activeOrderList.refresh();
  }

  Future<void> seeMoreActiveOrderList() async {
    activeOrderPageNum.value += 1;

    var activeOrderList = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));

    for (var activeOrder in activeOrderList) {
      activeOrder.orderRide = await orderRideRepository
          .getOrderRideDetailbyOrderId(
            orderId: activeOrder.orderId.toString(),
            language: languageServices.languageCodeSystem.value,
            orderType: activeOrder.orderType,
          );
    }

    if (activeOrderList.isEmpty) {
      activeOrderSeeMore.value = false;
    }

    this.activeOrderList.addAll(activeOrderList);
  }

  Future<void> getHistoryOrderList() async {
    historyOrderPageNum.value = 1;
    historyOrderSeeMore.value = true;

    var historyOrderList = (await orderRideRepository.getHistoryOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: historyOrderPageNum.value,
      size: historyOrderSize.value,
      type: historyOrderSelectedOrderType.value,
    ));

    for (var historyOrder in historyOrderList) {
      historyOrder.orderRide = await orderRideRepository
          .getOrderRideDetailbyOrderId(
            orderId: historyOrder.orderId.toString(),
            language: languageServices.languageCodeSystem.value,
            orderType: historyOrder.orderType,
          );
    }

    this.historyOrderList.value = historyOrderList;
  }

  Future<void> seeMoreHistoryOrderList() async {
    historyOrderPageNum.value += 1;

    var historyOrderList = (await orderRideRepository.getHistoryOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: historyOrderPageNum.value,
      size: historyOrderSize.value,
      type: historyOrderSelectedOrderType.value,
    ));

    for (var historyOrder in historyOrderList) {
      historyOrder.orderRide = await orderRideRepository
          .getOrderRideDetailbyOrderId(
            orderId: historyOrder.orderId.toString(),
            language: languageServices.languageCodeSystem.value,
            orderType: historyOrder.orderType,
          );
    }

    if (historyOrderList.isEmpty) {
      historyOrderSeeMore.value = false;
    }

    this.historyOrderList.addAll(historyOrderList);
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
