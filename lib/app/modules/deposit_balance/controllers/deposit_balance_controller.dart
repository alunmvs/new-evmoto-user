import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/payment_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DepositBalanceController extends GetxController {
  final PaymentRepository paymentRepository;
  final UserRepository userRepository;

  DepositBalanceController({
    required this.paymentRepository,
    required this.userRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final formGroup = FormGroup({
    "money": FormControl<String>(validators: <Validator>[Validators.required]),
  });

  final refreshController = RefreshController();

  final recommendationAmountList = [
    10000,
    15000,
    20000,
    25000,
    50000,
    100000,
  ].obs;

  final selectedRecommendationAmount = 0.obs;

  final userInfo = UserInfo().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getUserInfoDetail();
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

  Future<void> getUserInfoDetail() async {
    userInfo.value = await userRepository.getUserInfo(language: 2);
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      try {
        var money = double.parse(
          formGroup.control("money").value.toString().replaceAll(".", ""),
        );

        if (money < 10000) {
          final SnackBar snackBar = SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: themeColorServices.sematicColorRed400.value,
            content: Text(
              "Minimal pengisian saldo Rp10.000",
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: themeColorServices.neutralsColorGrey0.value,
              ),
            ),
          );
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
          return;
        }
        var depositBalance = await paymentRepository.depositBalance(
          language: 2,
          payType: 1,
          money: double.parse(
            formGroup.control("money").value.toString().replaceAll(".", ""),
          ),
          type: 2,
        );

        await Get.toNamed(
          Routes.DEPOSIT_BALANCE_PAYMENT_WEBVIEW,
          arguments: {"redirect_url": depositBalance.redirectUrl},
        );

        await getUserInfoDetail();
      } catch (e) {
        final SnackBar snackBar = SnackBar(
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
}
