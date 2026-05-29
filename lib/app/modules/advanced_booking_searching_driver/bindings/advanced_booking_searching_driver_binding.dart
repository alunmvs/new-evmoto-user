import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';

import '../controllers/advanced_booking_searching_driver_controller.dart';

class AdvancedBookingSearchingDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvancedBookingSearchingDriverController>(
      () => AdvancedBookingSearchingDriverController(
        advanceBookingRepository: AdvanceBookingRepository(),
        driverNearbyRepository: DriverNearbyRepository(),
      ),
    );
  }
}
