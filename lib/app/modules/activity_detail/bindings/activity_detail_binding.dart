import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/activity_detail_controller.dart';

class ActivityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityDetailController>(
      () => ActivityDetailController(
        googleMapsRepository: GoogleMapsRepository(),
        orderRideRepository: OrderRideRepository(),
      ),
    );
  }
}
