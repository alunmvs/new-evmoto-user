import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/ride_order_done_controller.dart';

class RideOrderDoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideOrderDoneController>(
      () => RideOrderDoneController(orderRideRepository: OrderRideRepository()),
    );
  }
}
