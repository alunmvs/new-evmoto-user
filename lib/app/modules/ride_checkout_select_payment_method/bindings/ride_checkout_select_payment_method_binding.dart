import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/repositories/payment_method_repository.dart';

import '../controllers/ride_checkout_select_payment_method_controller.dart';

class RideCheckoutSelectPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideCheckoutSelectPaymentMethodController>(
      () => RideCheckoutSelectPaymentMethodController(
        paymentMethodRepository: PaymentMethodRepository(),
        gopayPaymentRepository: GopayPaymentRepository(),
      ),
    );
  }
}
