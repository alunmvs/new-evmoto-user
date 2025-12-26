import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';

import '../controllers/login_register_verification_otp_controller.dart';

class LoginRegisterVerificationOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRegisterVerificationOtpController>(
      () => LoginRegisterVerificationOtpController(
        loginRegisterRepository: LoginRegisterRepository(),
        otpRepository: OtpRepository(),
      ),
    );
  }
}
