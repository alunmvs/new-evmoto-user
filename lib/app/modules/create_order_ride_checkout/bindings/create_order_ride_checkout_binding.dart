import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/create_order_ride_checkout_controller.dart';

class CreateOrderRideCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderRideCheckoutController>(
      () => CreateOrderRideCheckoutController(
        geocodingRepository: GeocodingRepository(),
        openMapsRepository: OpenMapsRepository(),
        orderRideRepository: OrderRideRepository(),
      ),
    );
  }
}
