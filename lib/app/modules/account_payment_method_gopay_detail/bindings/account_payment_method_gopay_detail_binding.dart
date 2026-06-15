import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';

import '../controllers/account_payment_method_gopay_detail_controller.dart';

class AccountPaymentMethodGopayDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountPaymentMethodGopayDetailController>(
      () => AccountPaymentMethodGopayDetailController(
        gopayPaymentRepository: GopayPaymentRepository(),
      ),
    );
  }
}
