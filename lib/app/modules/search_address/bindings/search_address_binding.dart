import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';

import '../controllers/search_address_controller.dart';

class SearchAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchAddressController>(
      () =>
          SearchAddressController(googleMapsRepository: GoogleMapsRepository()),
    );
  }
}
