import 'package:get/get.dart';

import '../controllers/setting_saved_location_controller.dart';

class SettingSavedLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingSavedLocationController>(
      () => SettingSavedLocationController(),
    );
  }
}
