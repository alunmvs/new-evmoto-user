import 'package:get/get.dart';

import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositBalancePaymentWebviewController>(
      () => DepositBalancePaymentWebviewController(),
    );
  }
}
