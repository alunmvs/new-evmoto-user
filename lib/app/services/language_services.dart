import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/language_model.dart';

class LanguageServices extends GetxService {
  final languageCode = "ID".obs;
  final languageCodeSystem = 3.obs;
  final language = Language().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadLanguageAssets(languageCode: "EN");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadLanguageAssets({required String languageCode}) async {
    this.languageCode.value = languageCode;

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
