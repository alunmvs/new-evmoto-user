import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';
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

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;

    await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);
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

  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          language: languageServices.languageCodeSystem.value,
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
      await Future.wait([
        orderRideRepository.paidOrder(
          orderId: orderId.value,
          payType: orderRideDetail.value.payType!,
          type: 1,
          orderType: orderType.value,
          language: languageServices.languageCodeSystem.value,
          couponId: orderRideDetail.value.couponId!,
        ),
      ]);

      Get.back();

      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          languageServices.language.value.snackbarCompleteOrderSuccess ?? "-",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      Get.dialog(LoadingDialog(), barrierDismissible: false);
      var processList = <Future>[];
      processList.add(homeController.refreshAll());
      if (Get.isRegistered<ActivityController>()) {
        var activityController = Get.find<ActivityController>();
        processList.add(activityController.refreshAll());
      }
      await Future.wait(processList);
      Get.close(1);

      await Get.toNamed(
        Routes.ACTIVITY_DETAIL,
        arguments: {"order_id": orderId.value, "order_type": orderType.value},
      );
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
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
}
