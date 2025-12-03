import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class HomeController extends GetxController {
  final UserRepository userRepository;

  HomeController({required this.userRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final bannerUrlList = [
    "assets/images/img_promo_1.png",
    "assets/images/img_promo_2.png",
  ];
  final indexBanner = 0.0.obs;
  final indexNavigationBar = 0.obs;

  final userInfo = UserInfo().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await refreshAll();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshAll() async {
    Future.wait([getUserInfo()]);
  }

  Future<void> getUserInfo() async {
    userInfo.value = (await userRepository.getUserInfo(
      language: languageServices.languageCodeSystem.value,
    ));
  }
}
