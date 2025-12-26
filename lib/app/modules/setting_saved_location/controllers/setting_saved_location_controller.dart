import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class SettingSavedLocationController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

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

  void onTapMoreOptions() async {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Menu Lainnya",
                          style: typographyServices.bodyLargeBold.value,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: 24,
                            height: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: themeColorServices.neutralsColorGrey200.value,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                            Get.toNamed(Routes.ADD_EDIT_ADDRESS);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  themeColorServices.neutralsColorGrey0.value,
                              border: Border.all(
                                color: themeColorServices
                                    .neutralsColorGrey300
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_edit.svg",
                                  width: 16,
                                  height: 16,
                                  color: themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Edit Alamat",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey600
                                            .value,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeColorServices.neutralsColorGrey0.value,
                            border: Border.all(
                              color:
                                  themeColorServices.neutralsColorGrey300.value,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_delete.svg",
                                width: 16,
                                height: 16,
                                color:
                                    themeColorServices.sematicColorRed400.value,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Hapus Alamat",
                                style: typographyServices.bodySmallRegular.value
                                    .copyWith(
                                      color: themeColorServices
                                          .sematicColorRed400
                                          .value,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
