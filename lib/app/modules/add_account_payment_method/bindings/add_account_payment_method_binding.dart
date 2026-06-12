import 'package:get/get.dart';

import '../controllers/add_account_payment_method_controller.dart';

class AddAccountPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAccountPaymentMethodController>(
      () => AddAccountPaymentMethodController(),
    );
  }
}
