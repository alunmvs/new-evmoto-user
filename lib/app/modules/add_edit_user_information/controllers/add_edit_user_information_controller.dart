import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddEditUserInformationController extends GetxController {
  final UploadImageRepository uploadImageRepository;
  final UserRepository userRepository;

  AddEditUserInformationController({
    required this.uploadImageRepository,
    required this.userRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final homeController = Get.find<HomeController>();

  final formGroup = FormGroup({
    "full_name": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "gender_type": FormControl<int>(validators: <Validator>[]),
    "mobile_number": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "email": FormControl<String>(validators: <Validator>[]),
  });

  final avatarImgUrl = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await prefillForm();
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

  Future<void> prefillForm() async {
    formGroup.control("mobile_number").value =
        homeController.userInfo.value.phone;
    formGroup.control("full_name").value = homeController.userInfo.value.name;
    formGroup.control("gender_type").value = homeController.userInfo.value.sex;
    avatarImgUrl.value = homeController.userInfo.value.avatar ?? "";
  }

  Future<void> onTapUpdateAvatar() async {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Unggah Foto Avatar",
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
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: Get.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFFE8E8E8)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await uploadAttachmentFromGallery();
                              },
                              child: Container(
                                width: Get.width,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Color(0XFFCFE9FC),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_gallery.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Galeri",
                                      style: typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: () async {
                                await uploadAttachmentFromCamera();
                              },
                              child: Container(
                                width: Get.width,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Color(0XFFCFE9FC),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_camera.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "Kamera",
                                      style: typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String addTimestamp(String filename) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final lastDot = filename.lastIndexOf('.');
    if (lastDot == -1) {
      return '${filename}_$timestamp';
    }

    final name = filename.substring(0, lastDot);
    final ext = filename.substring(lastDot);

    return '${name}_$timestamp$ext';
  }

  Future<void> uploadAttachmentFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();

      avatarImgUrl.value = (await uploadImageRepository.uploadUserAvatar(
        file: File(image.path),
        fileName: addTimestamp(image.name),
      ))!;

      Get.close(2);
    }
  }

  Future<void> uploadAttachmentFromCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();

      avatarImgUrl.value = (await uploadImageRepository.uploadUserAvatar(
        file: File(image.path),
        fileName: addTimestamp(image.name),
      ))!;

      Get.close(2);
    }
  }

  Future<void> onTapSubmit() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid == false) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          languageServices.language.value.snackbarRequiredNotSuccess ?? "-",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      return;
    }

    await userRepository.updateUserInformation(
      name: formGroup.control("full_name").value,
      genderType: formGroup.control("gender_type").value,
      avatarUrl: avatarImgUrl.value == "" ? null : avatarImgUrl.value,
      id: homeController.userInfo.value.id!,
    );

    await homeController.getUserInfo();

    Get.back();

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        "Berhasil menyimpan informasi pengguna",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    return;
  }
}
