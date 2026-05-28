import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';

import '../controllers/advanced_booking_detail_controller.dart';

class AdvancedBookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvancedBookingDetailController>(
      () => AdvancedBookingDetailController(
        openMapsRepository: OpenMapsRepository(),
        orderRideRepository: OrderRideRepository(),
        advanceBookingRepository: AdvanceBookingRepository(),
      ),
    );
  }
}
