import 'package:get/get.dart';

import '../controllers/account_payment_method_controller.dart';

class AccountPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountPaymentMethodController>(
      () => AccountPaymentMethodController(),
    );
  }
}
