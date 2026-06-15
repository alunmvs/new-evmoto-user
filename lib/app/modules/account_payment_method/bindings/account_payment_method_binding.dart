import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';

import '../controllers/account_payment_method_controller.dart';

class AccountPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountPaymentMethodController>(
      () => AccountPaymentMethodController(
        gopayPaymentRepository: GopayPaymentRepository(),
      ),
    );
  }
}
