import 'package:get/get.dart';

import '../controllers/introduction_package_service_controller.dart';

class IntroductionPackageServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionPackageServiceController>(
      () => IntroductionPackageServiceController(),
    );
  }
}
