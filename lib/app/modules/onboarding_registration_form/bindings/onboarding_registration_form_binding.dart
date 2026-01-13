import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';

import '../controllers/onboarding_registration_form_controller.dart';

class OnboardingRegistrationFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingRegistrationFormController>(
      () => OnboardingRegistrationFormController(
        userRepository: UserRepository(),
      ),
    );
  }
}
