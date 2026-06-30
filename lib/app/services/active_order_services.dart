import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/dispatch_expired_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/utils/dialog_helper.dart';
import 'package:new_evmoto_user/app/utils/dialog_tags.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/driver_busy_dialog.dart';
import 'package:new_evmoto_user/app/widgets/driver_not_available_dialog.dart';

class ActiveOrderServices extends GetxService {
  final orderRideRepository = OrderRideRepository();
  final languageServices = Get.find<LanguageServices>();

  String? _lastDispatchExpiredDialogKey;
  bool _isHandlingDispatchExpired = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> handleDispatchExpired({
    required DispatchExpired dispatchExpired,
    OrderRide? orderRide,
  }) async {
    final orderId = dispatchExpired.orderId?.toString();
    final orderType = dispatchExpired.orderType;
    if (orderId == null || orderType == null) {
      return;
    }

    final dialogKey = '${orderId}_$orderType';
    if (_isDispatchExpiredDialogAlreadyHandled(dialogKey)) {
      return;
    }
    if (_isHandlingDispatchExpired) {
      return;
    }

    _isHandlingDispatchExpired = true;
    _lastDispatchExpiredDialogKey = dialogKey;

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          if (_isDispatchExpiredDialogAlreadyShown()) {
            return;
          }

          await navigateToHomeBeforeDispatchExpiredDialog();

          DialogHelper.dismissIfExists(DialogTags.cancelOrderBeforeDriver);

          final hadPopup = await _resolveHadPopup(
            orderId: orderId,
            orderType: orderType,
            dispatchExpired: dispatchExpired,
          );

          final orderAgainArgs = await _buildOrderAgainArgs(
            orderId: orderId,
            orderType: orderType,
            orderRide: orderRide,
          );

          _showDispatchExpiredDialog(
            hadPopup: hadPopup,
            orderAgainArgs: orderAgainArgs,
          );

          await _refreshActiveOrderList();
        } finally {
          _isHandlingDispatchExpired = false;
        }
      });
    } catch (_) {
      _isHandlingDispatchExpired = false;
    }
  }

  Future<void> navigateToHomeBeforeDispatchExpiredDialog() async {
    var currentRoute = Get.currentRoute;

    if (currentRoute == Routes.CREATE_ORDER_RIDE) {
      await Future.delayed(const Duration(seconds: 3));
      currentRoute = Get.currentRoute;
    }

    if (currentRoute == Routes.ADVANCED_BOOKING_SEARCHING_DRIVER) {
      await Future.delayed(const Duration(seconds: 8));
      currentRoute = Get.currentRoute;
    }

    if (currentRoute == Routes.HOME) {
      _selectHomeTab();
      return;
    }

    if (Get.key.currentState?.canPop() ?? false) {
      Get.until((route) => Get.currentRoute == Routes.HOME);
    }

    _selectHomeTab();
  }

  bool _isDispatchExpiredDialogAlreadyHandled(String dialogKey) {
    return _lastDispatchExpiredDialogKey == dialogKey ||
        _isDispatchExpiredDialogAlreadyShown();
  }

  bool _isDispatchExpiredDialogAlreadyShown() {
    return DialogHelper.exists(DialogTags.driverBusy) ||
        DialogHelper.exists(DialogTags.driverNotAvailable);
  }

  void _selectHomeTab() {
    if (!Get.isRegistered<HomeController>()) {
      return;
    }
    Get.find<HomeController>().indexNavigationBar.value = 0;
  }

  Future<int> _resolveHadPopup({
    required String orderId,
    required int orderType,
    required DispatchExpired dispatchExpired,
  }) async {
    if (dispatchExpired.hadPopup != null) {
      return dispatchExpired.hadPopup!;
    }

    final expiredData = await orderRideRepository.queryDispatchExpired(
      orderId: orderId,
      orderType: orderType,
    );

    return expiredData.hadPopup ?? 0;
  }

  Future<Map<String, dynamic>> _buildOrderAgainArgs({
    required String orderId,
    required int orderType,
    OrderRide? orderRide,
  }) async {
    final order =
        orderRide ??
        await orderRideRepository.getOrderRideDetailbyOrderId(
          orderId: orderId,
          orderType: orderType,
        );

    return {
      'origin_address_name': order.startAddressName,
      'origin_address': order.startAddress,
      'origin_latitude': order.startLat.toString(),
      'origin_longitude': order.startLon.toString(),
      'destination_address_name': order.endAddressName,
      'destination_address': order.endAddress,
      'destination_latitude': order.endLat.toString(),
      'destination_longitude': order.endLon.toString(),
    };
  }

  void _showDispatchExpiredDialog({
    required int hadPopup,
    required Map<String, dynamic> orderAgainArgs,
  }) {
    Future<void> onTapOrderAgain() async {
      final activeOrderList = await orderRideRepository.getActiveOrderList(
        language: languageServices.languageCodeSystem.value,
      );

      if (activeOrderList.isNotEmpty) {
        SnackbarHelper.showSnackbarError(
          text: languageServices.language.value.snackbarOrderNotSuccess ?? '-',
        );
        return;
      }

      if (Get.isRegistered<HomeController>()) {
        await Get.find<HomeController>().getActiveOrderList();
      }

      DialogHelper.dismissIfExists(DialogTags.driverNotAvailable);
      DialogHelper.dismissIfExists(DialogTags.driverBusy);

      await Get.toNamed(Routes.CREATE_ORDER_RIDE, arguments: orderAgainArgs);
    }

    if (hadPopup >= 1) {
      DialogHelper.show(
        tag: DialogTags.driverBusy,
        widget: DriverBusyDialog(onTapOrderAgain: onTapOrderAgain),
      );
      return;
    }

    DialogHelper.show(
      tag: DialogTags.driverNotAvailable,
      widget: DriverNotAvailableDialog(onTapOrderAgain: onTapOrderAgain),
    );
  }

  Future<void> _refreshActiveOrderList() async {
    if (!Get.isRegistered<HomeController>()) {
      return;
    }
    await Get.find<HomeController>().getActiveOrderList();
  }
}
