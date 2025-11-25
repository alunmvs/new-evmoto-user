import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final isFetch = false.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 3)).whenComplete(() {
      Get.offAndToNamed(Routes.ONBOARDING_INTRODUCTION);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
