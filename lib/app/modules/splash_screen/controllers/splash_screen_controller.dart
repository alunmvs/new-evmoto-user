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
      await checkIfAppFirstRun();
      await getSplashScreenQueryImage();

      isFetch.value = false;

      var prefs = await SharedPreferences.getInstance();
      // print("[SOCKET DEBUG] ${prefs.getBool('home_controller_registered')}");
      await Future.wait([
        prefs.setBool("home_controller_registered", false),
        prefs.setBool("activity_controller_registered", false),
      ]);
      // print("[SOCKET DEBUG] ${prefs.getBool('home_controller_registered')}");

      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      if (token == null || token == "") {
        Future.delayed(Duration(seconds: 2)).whenComplete(() async {
          Get.offAndToNamed(Routes.LOGIN_REGISTER);
        });
      } else {
        await Future.wait([
          userServices.manualOnInit(),
          locationServices.requestLocationSplashScreen(),
          Future.delayed(Duration(seconds: 2)),
        ]);
        Get.offAndToNamed(Routes.HOME);
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
      isCriticalError.value = true;
      isFetch.value = false;
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
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
    var queryImageList = await queryImageRepository.getQueryImageList(
      type: 1,
      usePort: 1,
    );

    if (queryImageList.isNotEmpty) {
      splashScreenQueryImage.value =
          (await queryImageRepository.getQueryImageList(
            type: 1,
            usePort: 1,
          )).first;
    }
  }

  Future<void> checkIfAppFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('first_run') ?? true;

    if (isFirstRun) {
      var storage = FlutterSecureStorage();
      await storage.deleteAll();
      await prefs.setBool('first_run', false);
    }
  }
}
