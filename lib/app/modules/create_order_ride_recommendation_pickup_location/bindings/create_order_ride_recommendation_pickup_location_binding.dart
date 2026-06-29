import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';

import '../controllers/create_order_ride_recommendation_pickup_location_controller.dart';

class CreateOrderRideRecommendationPickupLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderRideRecommendationPickupLocationController>(
      () => CreateOrderRideRecommendationPickupLocationController(
        driverNearbyRepository: DriverNearbyRepository(),
        geocodingRepository: GeocodingRepository(),
      ),
    );
  }
}
