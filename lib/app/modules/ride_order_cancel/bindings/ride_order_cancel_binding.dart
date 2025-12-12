import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/ride_order_cancel_controller.dart';

class RideOrderCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideOrderCancelController>(
      () =>
          RideOrderCancelController(orderRideRepository: OrderRideRepository()),
    );
  }
}
