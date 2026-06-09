import 'package:get/get.dart';

import '../controllers/ride_call_sendbird_controller.dart';

class RideCallSendbirdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideCallSendbirdController>(
      () => RideCallSendbirdController(),
    );
  }
}
