import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
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
    "remark": FormControl<String>(
      validators: <Validator>[Validators.maxLength(150)],
    ),
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
      SnackbarHelper.showSnackbarError(
        text: languageServices.language.value.snackbarRequiredNotSuccess ?? "-",
      );
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
      SnackbarHelper.showSnackbarSuccess(
        text: languageServices.language.value.snackbarCancelOrderSuccess ?? "-",
      );
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }
}
