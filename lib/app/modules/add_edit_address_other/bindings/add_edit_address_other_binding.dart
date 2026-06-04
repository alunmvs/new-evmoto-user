import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';

import '../controllers/add_edit_address_other_controller.dart';

class AddEditAddressOtherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditAddressOtherController>(
      () => AddEditAddressOtherController(
        savedAddressRepository: SavedAddressRepository(),
        geocodingRepository: GeocodingRepository(),
      ),
    );
  }
}
