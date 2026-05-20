import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/repositories/advertisement_repository.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/repositories/versioning_server_repository.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        userRepository: UserRepository(),
        orderRideRepository: OrderRideRepository(),
        couponRepository: CouponRepository(),
        savedAddressRepository: SavedAddressRepository(),
        geocodingRepository: GeocodingRepository(),
        advertisementRepository: AdvertisementRepository(),
        versioningServerRepository: VersioningServerRepository(),
        driverNearbyRepository: DriverNearbyRepository(),
      ),
    );

    Get.lazyPut<AccountController>(
      () => AccountController(
        otpRepository: OtpRepository(),
        userRepository: UserRepository(),
        orderRideRepository: OrderRideRepository(),
      ),
    );

    Get.lazyPut<ActivityController>(
      () => ActivityController(orderRideRepository: OrderRideRepository()),
    );
  }
}
