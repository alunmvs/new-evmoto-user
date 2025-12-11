import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/ride_order_detail_controller.dart';

class RideOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideOrderDetailController>(
      () => RideOrderDetailController(
        googleMapsRepository: GoogleMapsRepository(),
        orderRideRepository: OrderRideRepository(),
      ),
    );
  }
}
