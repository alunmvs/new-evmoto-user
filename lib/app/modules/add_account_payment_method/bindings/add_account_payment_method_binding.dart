import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';

import '../controllers/add_account_payment_method_controller.dart';

class AddAccountPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAccountPaymentMethodController>(
      () => AddAccountPaymentMethodController(
        gopayPaymentRepository: GopayPaymentRepository(),
      ),
    );
  }
}
