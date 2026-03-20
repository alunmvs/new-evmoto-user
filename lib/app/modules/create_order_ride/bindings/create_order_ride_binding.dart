import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';

import '../controllers/create_order_ride_controller.dart';

class CreateOrderRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderRideController>(
      () => CreateOrderRideController(
        geocodingRepository: GeocodingRepository(),
        orderRideRepository: OrderRideRepository(),
        savedAddressRepository: SavedAddressRepository(),
      ),
    );
  }
}
