import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/activity_controller.dart';

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(
      () => ActivityController(orderRideRepository: OrderRideRepository()),
    );
  }
}
