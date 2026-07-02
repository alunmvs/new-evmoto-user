import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';

import '../controllers/login_register_controller.dart';

class LoginRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRegisterController>(
      () => LoginRegisterController(
        loginRegisterRepository: LoginRegisterRepository(),
      ),
      fenix: true,
    );
  }
}
