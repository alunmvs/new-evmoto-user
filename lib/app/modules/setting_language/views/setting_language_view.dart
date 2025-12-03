import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/setting_language_controller.dart';

class SettingLanguageView extends GetView<SettingLanguageController> {
  const SettingLanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Pilih Bahasa",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RadioGroup(
                        onChanged: (value) {
                          controller.tempLanguageCode.value = value!;
                        },
                        groupValue: controller.tempLanguageCode.value,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.tempLanguageCode.value = "ZH_CN";
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_flag_cn.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "简体中文 (ZH_CN)",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                    Spacer(),
                                    SizedBox(width: 12),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Radio(
                                        value: "ZH_CN",
                                        activeColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        backgroundColor:
                                            controller.tempLanguageCode.value ==
                                                "ZH_CN"
                                            ? WidgetStateProperty.all(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey200
                                  .value,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.tempLanguageCode.value = "EN";
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_flag_en.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "English (EN)",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                    Spacer(),
                                    SizedBox(width: 12),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Radio(
                                        value: "EN",
                                        activeColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        backgroundColor:
                                            controller.tempLanguageCode.value ==
                                                "EN"
                                            ? WidgetStateProperty.all(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey200
                                  .value,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.tempLanguageCode.value = "ID";
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_flag_id.svg",
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Bahasa Indonesia (ID)",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                    Spacer(),
                                    SizedBox(width: 12),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Radio(
                                        value: "ID",
                                        activeColor: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                        backgroundColor:
                                            controller.tempLanguageCode.value ==
                                                "ID"
                                            ? WidgetStateProperty.all(
                                                controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    controller.languageServices.switchLanguage(
                      languageCode: controller.tempLanguageCode.value,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Simpan",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
