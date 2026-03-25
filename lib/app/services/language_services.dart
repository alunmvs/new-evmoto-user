import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageServices extends GetxService {
  final languageCode = "ID".obs;
  final languageCodeSystem = 2.obs;
  final language = Language().obs;

  @override
  Future<void> onInit() async {
    super.onInit();

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
          currentLocale == "zh_Hant_TW") {
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
    this.languageCode.value = languageCode;

    if (isSave == true) {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
    }

    switch (languageCode) {
      case "ZH_CN":
        languageCodeSystem.value = 1;
        var jsonData = await rootBundle.loadString(
          'assets/jsons/user_lang_zh_cn.json',
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "EN":
        languageCodeSystem.value = 2;
        var jsonData = await rootBundle.loadString(
          'assets/jsons/user_lang_en.json',
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "ID":
        languageCodeSystem.value = 3;
        var jsonData = await rootBundle.loadString(
          'assets/jsons/user_lang_id.json',
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
    }
  }
}
