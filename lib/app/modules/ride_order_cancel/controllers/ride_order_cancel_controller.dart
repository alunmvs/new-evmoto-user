import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RideOrderCancelController extends GetxController {
  final OrderRideRepository orderRideRepository;

  RideOrderCancelController({required this.orderRideRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final formGroup = FormGroup({
    "reason": FormControl<String>(validators: <Validator>[Validators.required]),
    "remark": FormControl<String>(validators: <Validator>[]),
  });

  final orderId = "".obs;
  final orderType = 0.obs;

  final reason = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? "";
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

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid == false) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Harap lengkapi data yang dibutuhkan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    try {
      await orderRideRepository.cancelOrderRide(
        language: languageServices.languageCodeSystem.value,
        orderId: orderId.value,
        orderType: orderType.value,
        reason: formGroup.control("reason").value,
        remark: formGroup.control("remark").value,
      );

      Get.back();
      Get.back();

      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Berhasil membatalkan pesanan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
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
