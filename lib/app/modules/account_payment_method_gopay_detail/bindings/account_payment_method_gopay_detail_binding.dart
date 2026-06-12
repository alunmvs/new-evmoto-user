import 'package:get/get.dart';

import '../controllers/account_payment_method_gopay_detail_controller.dart';

class AccountPaymentMethodGopayDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountPaymentMethodGopayDetailController>(
      () => AccountPaymentMethodGopayDetailController(),
    );
  }
}
