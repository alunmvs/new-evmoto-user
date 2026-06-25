import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class CreateOrderRideRecommendationPickupLocationController
    extends GetxController {
  final DriverNearbyRepository driverNearbyRepository;
  final GeocodingRepository geocodingRepository;

  CreateOrderRideRecommendationPickupLocationController({
    required this.driverNearbyRepository,
    required this.geocodingRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  final originAddressName = Rx<String?>(null);
  final originAddress = Rx<String?>(null);
  final originLatitude = Rx<String?>(null);
  final originLongitude = Rx<String?>(null);
  final destinationAddressName = Rx<String?>(null);
  final destinationAddress = Rx<String?>(null);
  final destinationLatitude = Rx<String?>(null);
  final destinationLongitude = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fillForm();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fillForm() {
    originAddressName.value = Get.arguments['origin_address_name'];
    originAddress.value = Get.arguments['origin_address'];
    originLatitude.value = Get.arguments['origin_latitude'];
    originLongitude.value = Get.arguments['origin_longitude'];
    destinationAddressName.value = Get.arguments['destination_address_name'];
    destinationAddress.value = Get.arguments['destination_address'];
    destinationLatitude.value = Get.arguments['destination_latitude'];
    destinationLongitude.value = Get.arguments['destination_longitude'];
  }
}
