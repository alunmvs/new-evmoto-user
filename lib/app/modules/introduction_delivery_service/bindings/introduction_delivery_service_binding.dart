import 'package:get/get.dart';

import '../controllers/introduction_delivery_service_controller.dart';

class IntroductionDeliveryServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionDeliveryServiceController>(
      () => IntroductionDeliveryServiceController(),
    );
  }
}
