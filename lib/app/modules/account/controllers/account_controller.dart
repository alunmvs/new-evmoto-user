import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final packageVersion = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getPackageInfo();
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

  Future<void> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageVersion.value = packageInfo.version;
  }

  Future<void> onTapLogout() async {
    var storage = FlutterSecureStorage();
    await storage.deleteAll();

    Get.offAndToNamed(Routes.LOGIN_REGISTER);
  }
}
