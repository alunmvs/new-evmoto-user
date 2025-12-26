import 'package:get/get.dart';

import '../controllers/ride_call_controller.dart';

class RideCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideCallController>(
      () => RideCallController(),
    );
  }
}
