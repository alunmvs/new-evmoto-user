import 'package:get/get.dart';

import '../controllers/add_edit_address_controller.dart';

class AddEditAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditAddressController>(
      () => AddEditAddressController(),
    );
  }
}
