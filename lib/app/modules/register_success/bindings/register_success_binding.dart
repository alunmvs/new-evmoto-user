import 'package:get/get.dart';

import '../controllers/register_success_controller.dart';

class RegisterSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterSuccessController>(
      () => RegisterSuccessController(),
    );
  }
}
