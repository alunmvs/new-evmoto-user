import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';

class RideOrderDoneController extends GetxController {
  final OrderRideRepository orderRideRepository;

  RideOrderDoneController({required this.orderRideRepository});

  final homeController = Get.find<HomeController>();
  final activityController = Get.find<ActivityController>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderRideDetail = OrderRide().obs;
  final orderRideServerDetail = OrderRideServer().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  final rating = 0.0.obs;

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
      if (rating.value == 0.0) {
        await Future.wait([
          orderRideRepository.paidOrder(
            orderId: orderId.value,
            payType: 3,
            type: 1,
            orderType: orderType.value,
            language: languageServices.languageCodeSystem.value,
          ),
        ]);
      } else {
        await Future.wait([
          orderRideRepository.submitRatingAndReviewOrder(
            orderType: orderType.value,
            orderId: orderId.value,
            content: null,
            fraction: rating.value,
            language: languageServices.languageCodeSystem.value,
          ),
          orderRideRepository.paidOrder(
            orderId: orderId.value,
            payType: 3,
            type: 1,
            orderType: orderType.value,
            language: languageServices.languageCodeSystem.value,
          ),
        ]);
      }

      await Future.wait([homeController.refreshAll()]);

      Get.back();

      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Berhasil menyelesaikan pesanan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );

      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      await Future.wait([activityController.refreshAll()]);
    } catch (e) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
