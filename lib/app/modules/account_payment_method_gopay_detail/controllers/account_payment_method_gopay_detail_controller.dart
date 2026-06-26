import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/gopay_balance_model.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_status_model.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/dialogs/payment_method_gopay_main_method_confirmation_dialog.dart';
import 'package:new_evmoto_user/app/widgets/dialogs/payment_method_gopay_unbind_confirmation_dialog.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AccountPaymentMethodGopayDetailController extends GetxController {
  final GopayPaymentRepository gopayPaymentRepository;

  AccountPaymentMethodGopayDetailController({
    required this.gopayPaymentRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();
  final isFetch = false.obs;
  final gopayLinkStatus = GopayLinkStatus().obs;
  final gopayBalance = GopayBalance().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    try {
      await getGopayData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isFetch.value = false;
  }

  Future<void> refreshAll() async {
    try {
      await getGopayData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> getGopayData() async {
    gopayLinkStatus.value = await gopayPaymentRepository.getGopayLinkStatus();

    if (gopayLinkStatus.value.linked == true) {
      gopayBalance.value = await gopayPaymentRepository.getGopayBalance();
    } else {
      gopayBalance.value = GopayBalance();
    }
  }

  Future<void> onTapCopyAccountNumber() async {
    final phoneNumber = gopayLinkStatus.value.phoneNumber ?? '';
    if (phoneNumber.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: phoneNumber));
    SnackbarHelper.showSnackbarSuccess(text: "Nomor akun disalin");
  }

  Future<void> onTapSetAsMainMethod() async {
    await Get.dialog(
      PaymentMethodGopayMainMethodConfirmationDialog(),
      barrierDismissible: true,
    );
  }

  Future<void> onTapCancelPaymentMethod() async {
    await Get.dialog(
      PaymentMethodGopayUnbindConfirmationDialog(
        onTapConfirm: () async {
          try {
            await gopayPaymentRepository.unlinkGopay();
            Get.close(1);
            Get.back();
            SnackbarHelper.showSnackbarSuccess(
              text: "Metode pembayaran GoPay berhasil dibatalkan",
            );
          } on DioException catch (e) {
            SnackbarHelper.showSnackbarError(text: e.error.toString());
          } catch (e) {
            SnackbarHelper.showSnackbarError(text: e.toString());
          }
        },
      ),
      barrierDismissible: true,
    );
  }
}
