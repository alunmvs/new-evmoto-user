import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';

import '../controllers/ride_controller.dart';

class RideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideController>(
      () => RideController(
        googleMapsRepository: GoogleMapsRepository(),
        orderRideRepository: OrderRideRepository(),
        savedAddressRepository: SavedAddressRepository(),
        openMapsRepository: OpenMapsRepository(),
      ),
    );
  }
}
