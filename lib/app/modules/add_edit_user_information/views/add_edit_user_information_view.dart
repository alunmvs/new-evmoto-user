import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/add_edit_user_information_controller.dart';

class AddEditUserInformationView
    extends GetView<AddEditUserInformationController> {
  const AddEditUserInformationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Ubah Informasi Pengguna",
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
            if (controller.isFetch.value == true) ...[
              Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              ),
            ],
            if (controller.isFetch.value == false) ...[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ReactiveForm(
                    formGroup: controller.formGroup,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Foto Avatar",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                        SizedBox(height: 8),
                        if (controller.avatarImgUrl.value == "") ...[
                          GestureDetector(
                            onTap: () async {
                              await controller.onTapUpdateAvatar();
                            },
                            child: CircleAvatar(
                              backgroundColor: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              radius: 40,
                              child: SvgPicture.asset(
                                "assets/icons/icon_image_upload.svg",
                              ),
                            ),
                          ),
                        ],
                        if (controller.avatarImgUrl.value != "") ...[
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                radius: 40,
                                backgroundImage: CachedNetworkImageProvider(
                                  controller.avatarImgUrl.value,
                                ),
                              ),
                              SizedBox(width: 16),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await controller.onTapUpdateAvatar();
                                      },
                                      child: Text(
                                        "Ubah Foto",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    VerticalDivider(
                                      width: 0,
                                      color: Color(0XFFB3B3B3),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        controller.avatarImgUrl.value = "";
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_delete.svg",
                                            width: 12,
                                            height: 12,
                                            color: controller
                                                .themeColorServices
                                                .sematicColorRed400
                                                .value,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .delete ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
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
                            ],
                          ),
                        ],
                        SizedBox(height: 16),
                        Text(
                          "Nama Lengkap",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                        SizedBox(height: 8),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          formControlName: 'full_name',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintText: "Masukkan nama lengkap",
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Jenis Kelamin",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                        SizedBox(height: 8),
                        ReactiveDropdownField(
                          isExpanded: true,
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value
                              .copyWith(color: Colors.black),
                          dropdownColor: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          validationMessages: {
                            ValidationMessage.required: (error) =>
                                "Wajib diisi",
                          },
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(
                                "Laki-laki",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                                softWrap: true,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                "Perempuan",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value,
                                softWrap: true,
                              ),
                            ),
                          ],
                          formControlName: 'gender_type',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            suffix: SizedBox(width: 12),
                            prefix: SizedBox(width: 12),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 12),
                                Text(
                                  "Pilih jenis kelamin",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ],
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Nomor HP",
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                        SizedBox(height: 8),
                        ReactiveTextField(
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          cursorErrorColor:
                              controller.themeColorServices.primaryBlue.value,
                          readOnly: true,
                          formControlName: 'mobile_number',
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            hintText: "Masukkan nomor HP",
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                            errorStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorRed500
                                      .value,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .sematicColorRed500
                                    .value,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey400
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        // Text(
                        //   "Email",
                        //   style: controller
                        //       .typographyServices
                        //       .bodySmallRegular
                        //       .value,
                        // ),
                        // SizedBox(height: 8),
                        // SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapSubmit();
                },
                child: Text(
                  "Simpan",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
