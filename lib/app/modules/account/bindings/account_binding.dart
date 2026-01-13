import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';

import '../controllers/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(
      () => AccountController(
        otpRepository: OtpRepository(),
        userRepository: UserRepository(),
      ),
    );
  }
}
