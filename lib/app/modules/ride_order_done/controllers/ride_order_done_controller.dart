import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RideOrderDoneController extends GetxController {
  final OrderRideRepository orderRideRepository;

  RideOrderDoneController({required this.orderRideRepository});

  final formGroup = FormGroup({
    "review": FormControl<String>(validators: <Validator>[]),
  });

  final homeController = Get.find<HomeController>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderRideDetail = OrderRide().obs;
  final orderRideServerDetail = OrderRideServer().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  final rating = 5.0.obs;

  Timer? refreshOrderStateTimer;

  final waitingDriverConfirmStartAt = DateTime.now().obs;
  final showIHavePaidButton = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;

    await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);

    if (orderRideDetail.value.driverConfirmFeesAt != null) {
      waitingDriverConfirmStartAt.value = DateTime.parse(
        orderRideDetail.value.driverConfirmFeesAt!.replaceFirst(' ', 'T'),
      );
    }

    checkShowIHavePaidButton();

    refreshOrderStateTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);

      if (orderRideDetail.value.state == 8) {
        Get.back();
        SnackbarHelper.showSnackbarSuccess(
          text:
              languageServices.language.value.snackbarCompleteOrderSuccess ??
              "-",
        );
        await Get.toNamed(
          Routes.ACTIVITY_DETAIL,
          arguments: {"order_id": orderId.value, "order_type": orderType.value},
        );
      }

      checkShowIHavePaidButton();
    });
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    refreshOrderStateTimer?.cancel();
  }

  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          orderId: orderId.value,
          orderType: orderType.value,
        ));
  }

  Future<void> getOrderRideServerDetail() async {
    orderRideServerDetail.value = (await orderRideRepository
        .getOrderRideServerDetail(
          language: languageServices.languageCodeSystem.value,
          orderId: orderId.value,
          orderType: orderType.value,
        ));
  }

  Future<void> onTapDone() async {
    try {
      await orderRideRepository.confirmPayment(orderId: orderId.value);
      Get.back();
      SnackbarHelper.showSnackbarSuccess(
        text:
            languageServices.language.value.snackbarCompleteOrderSuccess ?? "-",
      );
      await Get.toNamed(
        Routes.ACTIVITY_DETAIL,
        arguments: {"order_id": orderId.value, "order_type": orderType.value},
      );
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } on Exception catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  double getTravelFare() {
    var travelFare = 0.0;

    travelFare += orderRideDetail.value.startMoney ?? 0.0;
    travelFare += orderRideDetail.value.waitMoney ?? 0.0;
    travelFare += orderRideDetail.value.mileageMoney ?? 0.0;
    travelFare += orderRideDetail.value.durationMoney ?? 0.0;
    travelFare += orderRideDetail.value.longDistanceMoney ?? 0.0;
    travelFare += orderRideDetail.value.nightMoney ?? 0.0;
    travelFare += orderRideDetail.value.fastigiumMoney ?? 0.0;

    return travelFare;
  }

  double getPromoMoney() {
    var promoMoney = 0.0;
    if (orderRideDetail.value.couponMoney != null &&
        orderRideDetail.value.couponMoney != 0) {
      promoMoney += orderRideDetail.value.couponMoney!;
      return promoMoney;
    }
    promoMoney += orderRideDetail.value.discountMoney ?? 0.0;
    return promoMoney;
  }

  void checkShowIHavePaidButton() {
    if (DateTime.now()
            .difference(waitingDriverConfirmStartAt.value)
            .inMinutes >=
        5) {
      showIHavePaidButton.value = true;
    }
  }
}
