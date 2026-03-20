import 'package:get/get.dart';

import '../controllers/create_order_ride_promo_controller.dart';

class CreateOrderRidePromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderRidePromoController>(
      () => CreateOrderRidePromoController(),
    );
  }
}
