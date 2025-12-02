import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final isFetch = false.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 3)).whenComplete(() async {
      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      if (token == null || token == "") {
        Get.offAndToNamed(Routes.ONBOARDING_INTRODUCTION);
      } else {
        Get.offAndToNamed(Routes.HOME);
      }
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
