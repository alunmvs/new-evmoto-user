import 'package:get/get.dart';

import '../controllers/onboarding_registration_form_controller.dart';

class OnboardingRegistrationFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingRegistrationFormController>(
      () => OnboardingRegistrationFormController(),
    );
  }
}
