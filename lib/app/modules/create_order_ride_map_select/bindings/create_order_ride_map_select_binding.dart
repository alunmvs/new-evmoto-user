import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';

import '../controllers/create_order_ride_map_select_controller.dart';

class CreateOrderRideMapSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderRideMapSelectController>(
      () => CreateOrderRideMapSelectController(
        geocodingRepository: GeocodingRepository(),
      ),
    );
  }
}
