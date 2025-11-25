import 'package:get/get.dart';

import '../controllers/login_register_verification_otp_controller.dart';

class LoginRegisterVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRegisterVerificationOtpController>(
      () => LoginRegisterVerificationOtpController(),
    );
  }
}
