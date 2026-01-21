import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class SettingSavedLocationController extends GetxController {
  final SavedAddressRepository savedAddressRepository;

  SettingSavedLocationController({required this.savedAddressRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final savedAddressList = <SavedAddress>[].obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getSavedAddressList();
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

  Future<void> getSavedAddressList() async {
    savedAddressList.value = (await savedAddressRepository
        .getSavedAddressList());
  }

  Future<void> onTapMoreOptions({required SavedAddress savedAddress}) async {
    await Get.bottomSheet(
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
                            Get.toNamed(
                              Routes.ADD_EDIT_ADDRESS,
                              arguments: {"saved_address": savedAddress},
                            );
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
                        GestureDetector(
                          onTap: () async {
                            Get.close(1);
                            await onTapDeleteAddress(
                              savedAddress: savedAddress,
                            );
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
                                  "assets/icons/icon_delete.svg",
                                  width: 16,
                                  height: 16,
                                  color: themeColorServices
                                      .sematicColorRed400
                                      .value,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Hapus Alamat",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: themeColorServices
                                            .sematicColorRed400
                                            .value,
                                      ),
                                ),
                              ],
                            ),
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
      isScrollControlled: true,
    );
  }

  Future<void> onTapAddLocation() async {
    await Get.bottomSheet(
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
                          languageServices.language.value.selectLocationType ??
                              "-",
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
                          onTap: () async {
                            Get.close(1);

                            await Get.toNamed(
                              Routes.SEARCH_ADDRESS,
                              arguments: {"address_type": 1},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: themeColorServices
                                    .neutralsColorGrey200
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_home.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  languageServices
                                          .language
                                          .value
                                          .addLocationHome ??
                                      "-",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            Get.close(1);

                            await Get.toNamed(
                              Routes.SEARCH_ADDRESS,
                              arguments: {"address_type": 2},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: themeColorServices
                                    .neutralsColorGrey200
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_office.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  languageServices
                                          .language
                                          .value
                                          .addLocationOffice ??
                                      "-",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            Get.close(1);

                            await Get.toNamed(
                              Routes.SEARCH_ADDRESS,
                              arguments: {"address_type": 3},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: themeColorServices
                                    .neutralsColorGrey200
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_add_square.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  languageServices
                                          .language
                                          .value
                                          .addLocationOther ??
                                      "-",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(),
                                ),
                              ],
                            ),
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
      isScrollControlled: true,
    );
  }

  Future<void> onTapDeleteAddress({required SavedAddress savedAddress}) async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        languageServices
                                .language
                                .value
                                .deleteAddressConfirmation ??
                            "-",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Batal",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              width: Get.width,
                              height: 46,
                              child: LoaderElevatedButton(
                                onPressed: () async {
                                  try {
                                    await savedAddressRepository
                                        .deleteSavedAddress(
                                          id: savedAddress.id!,
                                        );
                                    Get.close(1);
                                    var snackBar = SnackBar(
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: themeColorServices
                                          .sematicColorGreen400
                                          .value,
                                      content: Text(
                                        languageServices
                                                .language
                                                .value
                                                .snackbarDeleteAddressSuccess ??
                                            "-",
                                        style: typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                      ),
                                    );
                                    rootScaffoldMessengerKey.currentState
                                        ?.showSnackBar(snackBar);

                                    await getSavedAddressList();
                                  } catch (e) {
                                    var snackBar = SnackBar(
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: themeColorServices
                                          .sematicColorRed400
                                          .value,
                                      content: Text(
                                        e.toString(),
                                        style: typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                      ),
                                    );
                                    rootScaffoldMessengerKey.currentState
                                        ?.showSnackBar(snackBar);
                                  }
                                },
                                buttonColor:
                                    themeColorServices.sematicColorRed400.value,
                                child: Text(
                                  languageServices.language.value.delete ?? "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
