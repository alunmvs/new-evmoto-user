import 'package:get/get.dart';

import '../controllers/onboarding_introduction_controller.dart';

class OnboardingIntroductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingIntroductionController>(
      () => OnboardingIntroductionController(),
    );
  }
}
