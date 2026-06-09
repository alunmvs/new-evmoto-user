import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/query_image_repository.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(
      () =>
          SplashScreenController(queryImageRepository: QueryImageRepository()),
    );
  }
}
