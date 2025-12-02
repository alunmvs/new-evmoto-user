import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingIntroductionController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final pageNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onTapNext() async {
    if (pageNumber.value == 0) {
      pageNumber.value = 1;
    } else if (pageNumber.value == 1) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_onboarding_introduction_shown', true);
      Get.offAndToNamed(Routes.LOGIN_REGISTER);
    }
  }
}
