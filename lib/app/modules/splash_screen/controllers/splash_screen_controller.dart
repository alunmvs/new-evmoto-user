import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/query_image_model.dart';
import 'package:new_evmoto_user/app/repositories/query_image_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  final QueryImageRepository queryImageRepository;

  SplashScreenController({required this.queryImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final userServices = Get.find<UserServices>();
  final locationServices = Get.find<LocationServices>();

  final splashScreenQueryImage = QueryImage().obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    try {
      await getSplashScreenQueryImage();

      isFetch.value = false;

      var prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setBool("home_controller_registered", false),
        prefs.setBool("activity_controller_registered", false),
      ]);

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      if (token == null || token == "") {
        Get.offAndToNamed(Routes.LOGIN_REGISTER);
      } else {
        await Future.wait([
          userServices.manualOnInit(),
          locationServices.requestLocationSplashScreen(),
        ]);
        Get.offAndToNamed(Routes.HOME);
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
      isCriticalError.value = true;
      isFetch.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getSplashScreenQueryImage() async {
    splashScreenQueryImage.value =
        (await queryImageRepository.getQueryImageList(
          type: 1,
          usePort: 1,
        )).first;
  }
}
