import 'package:get/get.dart';

import '../controllers/ride_checkout_select_payment_method_controller.dart';

class RideCheckoutSelectPaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideCheckoutSelectPaymentMethodController>(
      () => RideCheckoutSelectPaymentMethodController(),
    );
  }
}
