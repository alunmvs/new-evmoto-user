import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';

import '../controllers/add_edit_address_controller.dart';

class AddEditAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditAddressController>(
      () => AddEditAddressController(
        savedAddressRepository: SavedAddressRepository(),
      ),
    );
  }
}
