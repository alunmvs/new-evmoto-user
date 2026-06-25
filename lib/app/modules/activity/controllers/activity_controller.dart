import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/order_helper.dart';

import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRideRepository orderRideRepository;
  final AdvanceBookingRepository advancedBookingRepository;

  ActivityController({
    required this.orderRideRepository,
    required this.advancedBookingRepository,
  });

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
  final activeOrderSize = 9999.obs;
  final activeOrderSeeMore = true.obs;

  final historyOrderRefreshController = RefreshController();
  final historyOrderList = <HistoryOrder>[].obs;
  final historyOrderPageNum = 1.obs;
  final historyOrderSize = 10.obs;
  final historyOrderSeeMore = true.obs;

  final advancedBookingRefreshController = RefreshController();
  final advancedBookingList = <AdvancedBooking>[].obs;
  final advancedBookingPageNum = 1.obs;
  final advancedBookingSize = 10.obs;
  final advancedBookingSeeMore = true.obs;

  final historyOrderSelectedOrderType = 1.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      indexTabBar.value = tabController.index;
    });

    try {
      await Future.wait([getHistoryOrderList(), getAdvancedBookingList()]);
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isFetch.value = false;

    await setActivityControllerRegistered();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> setActivityControllerRegistered() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('activity_controller_registered', true);
  }

  Future<void> refreshAll() async {
    try {
      await Future.wait([getHistoryOrderList()]);
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> refreshAllAdvancedBooking() async {
    try {
      await Future.wait([getAdvancedBookingList()]);
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> getActiveOrderList() async {
    activeOrderPageNum.value = 1;
    activeOrderSeeMore.value = true;

    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: activeOrderPageNum.value,
      size: activeOrderSize.value,
    ));

    activeOrderList.refresh();
  }

  Future<void> seeMoreActiveOrderList() async {
    activeOrderPageNum.value += 1;

    var activeOrderList = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: activeOrderPageNum.value,
      size: activeOrderSize.value,
    ));

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

    if (historyOrderList.isEmpty) {
      historyOrderSeeMore.value = false;
    }

    this.historyOrderList.addAll(historyOrderList);
  }

  Future<void> getAdvancedBookingList() async {
    advancedBookingPageNum.value = 1;
    advancedBookingSeeMore.value = true;

    advancedBookingList.value =
        (await advancedBookingRepository.getAdvancedBookingList(
          pageNo: advancedBookingPageNum.value,
          pageSize: advancedBookingSize.value,
        )) ??
        <AdvancedBooking>[];

    advancedBookingList.refresh();
  }

  Future<void> seeMoreAdvancedBookingList() async {
    advancedBookingPageNum.value += 1;

    var advancedBookingList = (await advancedBookingRepository
        .getAdvancedBookingList(
          pageNo: advancedBookingPageNum.value,
          pageSize: advancedBookingSize.value,
        ));

    if (advancedBookingList?.isEmpty ?? true) {
      advancedBookingSeeMore.value = false;
    }

    this.advancedBookingList.addAll(advancedBookingList ?? <AdvancedBooking>[]);
  }

  Future<void> onTapOrderAgain({required HistoryOrder historyOrder}) async {
    await homeController.getActiveOrderList();
    if (homeController.isActiveOrderListNotEmpty.value) {
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarOrderNotSuccess ?? "-",
      );
      return;
    }

    await Get.toNamed(
      Routes.CREATE_ORDER_RIDE,
      arguments: {
        "origin_address_name": historyOrder.startAddressName,
        "origin_address": historyOrder.startAddress,
        "origin_latitude": historyOrder.startLat.toString(),
        "origin_longitude": historyOrder.startLon.toString(),
        "destination_address_name": historyOrder.endAddressName,
        "destination_address": historyOrder.endAddress,
        "destination_latitude": historyOrder.endLat.toString(),
        "destination_longitude": historyOrder.endLon.toString(),
      },
    );
  }

  Future<void> onTapActivity({required HistoryOrder historyOrder}) async {
    if (OrderState.ACTIVE_STATE_LIST.contains(historyOrder.state)) {
      try {
        var isCancelled = await isOrderHasBeenCancelled(
          orderId: historyOrder.orderId.toString(),
          orderType: historyOrder.orderType!,
        );

        if (isCancelled == true) {
          SnackbarHelper.showSnackbarError(
            text: languageServices.language.value.orderHasBeenCancelled ?? "-",
          );
          await refreshAll();
          return;
        }
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
      } catch (e) {
        SnackbarHelper.showSnackbarError(text: e.toString());
      }
      await Get.toNamed(
        Routes.RIDE_ORDER_DETAIL,
        arguments: {
          "order_id": historyOrder.orderId.toString(),
          "order_type": historyOrder.orderType,
        },
      );
    } else {
      await Get.toNamed(
        Routes.ACTIVITY_DETAIL,
        arguments: {
          "order_id": historyOrder.orderId.toString(),
          "order_type": historyOrder.orderType,
        },
      );
    }

    await refreshAll();
  }

  Future<void> onTapOrderAgainAdvancedBooking({
    required AdvancedBooking advancedBooking,
  }) async {
    await homeController.getActiveOrderList();
    if (homeController.isActiveOrderListNotEmpty.value) {
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarOrderNotSuccess ?? "-",
      );
      return;
    }

    await Get.toNamed(
      Routes.CREATE_ORDER_RIDE,
      arguments: {
        "origin_address_name": advancedBooking.startAddressName,
        "origin_address": advancedBooking.startAddress,
        "origin_latitude": advancedBooking.startLat.toString(),
        "origin_longitude": advancedBooking.startLon.toString(),
        "destination_address_name": advancedBooking.endAddressName,
        "destination_address": advancedBooking.endAddress,
        "destination_latitude": advancedBooking.endLat.toString(),
        "destination_longitude": advancedBooking.endLon.toString(),
      },
    );
  }

  Future<void> onTapActivityAdvancedBooking({
    required AdvancedBooking advancedBooking,
  }) async {
    await Get.toNamed(
      Routes.ADVANCED_BOOKING_DETAIL,
      arguments: {"id": advancedBooking.id},
    );

    await refreshAllAdvancedBooking();
  }
}
