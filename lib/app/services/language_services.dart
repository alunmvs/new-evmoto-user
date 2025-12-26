import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
      await switchLanguage(languageCode: languageCode);
    } else {
      await switchLanguage(languageCode: "ID");
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

  Future<void> switchLanguage({required String languageCode}) async {
    this.languageCode.value = languageCode;

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    switch (languageCode) {
      case "ZH_CN":
        languageCodeSystem.value = 1;
        var jsonData = await rootBundle.loadString(
          'assets/jsons/lang_zh_cn.json',
        );
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "EN":
        languageCodeSystem.value = 2;
        var jsonData = await rootBundle.loadString('assets/jsons/lang_en.json');
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
      case "ID":
        languageCodeSystem.value = 3;
        var jsonData = await rootBundle.loadString('assets/jsons/lang_id.json');
        language.value = Language.fromJson(jsonDecode(jsonData));
        break;
    }
  }
}
