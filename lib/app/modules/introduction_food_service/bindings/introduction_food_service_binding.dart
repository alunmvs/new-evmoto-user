import 'package:get/get.dart';

import '../controllers/introduction_food_service_controller.dart';

class IntroductionFoodServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionFoodServiceController>(
      () => IntroductionFoodServiceController(),
    );
  }
}
