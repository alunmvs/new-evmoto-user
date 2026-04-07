import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageServices extends GetxService {
  final languageGeocoding = "id".obs;
  final languageCode = "ID".obs;
  final languageCodeSystem = 2.obs;
  final language = Language().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> manualOnInit() async {
    var prefs = await SharedPreferences.getInstance();
    var languageCode = prefs.getString('language_code');

    if (languageCode != null) {
      await switchLanguage(languageCode: languageCode, isSave: false);
    } else {
      var currentLocale = PlatformDispatcher.instance.locale.toString();

      var languageCode = "ID";

      if (currentLocale == "id" || currentLocale == "id_ID") {
        languageCode = "ID";
      }

      if (currentLocale == "en" ||
          currentLocale == "en_US" ||
          currentLocale == "en_GB") {
        languageCode = "EN";
      }

      if (currentLocale == "zh" ||
          currentLocale == "zh_CN" ||
          currentLocale == "zh_TW" ||
          currentLocale == "zh_Hant_TW" ||
          currentLocale == "zh_Hans_MO") {
        languageCode = "ZH_CN";
      }

      await switchLanguage(languageCode: languageCode, isSave: false);
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

  Future<void> switchLanguage({
    required String languageCode,
    required bool isSave,
  }) async {
    var firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
    this.languageCode.value = languageCode;

    if (isSave == true) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
    }

    switch (languageCode) {
      case "ZH_CN":
        languageCodeSystem.value = 1;
        languageGeocoding.value = "zh-CN";
        var jsonData = firebaseRemoteConfigServices.remoteConfig.getString(
          "user_lang_zh_cn",
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "EN":
        languageCodeSystem.value = 2;
        languageGeocoding.value = "en";
        var jsonData = firebaseRemoteConfigServices.remoteConfig.getString(
          "user_lang_en",
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "ID":
        languageCodeSystem.value = 3;
        languageGeocoding.value = "id";
        var jsonData = firebaseRemoteConfigServices.remoteConfig.getString(
          "user_lang_id",
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
    }
  }
}
