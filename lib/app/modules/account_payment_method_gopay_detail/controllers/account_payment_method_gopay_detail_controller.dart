import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/dialogs/payment_method_gopay_main_method_confirmation_dialog.dart';
import 'package:new_evmoto_user/app/widgets/dialogs/payment_method_gopay_unbind_confirmation_dialog.dart';

class AccountPaymentMethodGopayDetailController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final isFetch = false.obs;
  final balance = "Rp32.000".obs;
  final accountNumber = "08123456789".obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onTapCopyAccountNumber() async {
    await Clipboard.setData(ClipboardData(text: accountNumber.value));
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
      PaymentMethodGopayUnbindConfirmationDialog(),
      barrierDismissible: true,
    );
  }
}
