import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';

import '../controllers/setting_saved_location_controller.dart';

class SettingSavedLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingSavedLocationController>(
      () => SettingSavedLocationController(
        savedAddressRepository: SavedAddressRepository(),
      ),
    );
  }
}
