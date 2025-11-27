import 'package:get/get.dart';

import '../controllers/setting_payment_controller.dart';

class SettingPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingPaymentController>(
      () => SettingPaymentController(),
    );
  }
}
