import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/add_edit_address_other_controller.dart';

class AddEditAddressOtherView extends GetView<AddEditAddressOtherController> {
  const AddEditAddressOtherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah Lokasi Lainnya",
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
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 375 / 96,
                  child: Container(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Expanded(
                  child: Container(
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
                ),
              ],
            ),
            if (controller.isFetch.value) ...[
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ReactiveForm(
                        formGroup: controller.formGroup,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .sematicColorBlue100
                                    .value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_pinpoint.svg",
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                      controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "Nama Lokasi",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                                Text(
                                  "*",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(color: Color(0XFFF44336)),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            ReactiveTextField(
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                              cursorErrorColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              formControlName: 'address_name',
                              onChanged: (control) {
                                controller.refreshIsFormValid();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                hintText:
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .enterName ??
                                    "-",
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Za-z0-9 ]'),
                                ),
                              ],
                              validationMessages: {
                                ValidationMessage.required: (error) =>
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .requiredFields ??
                                    "-",
                                ValidationMessage.maxLength: (error) =>
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .maxCharacter50 ??
                                    "-",
                              },
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  "Masukan Lokasi",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                                Text(
                                  "*",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(color: Color(0XFFF44336)),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            TextField(
                              controller: controller.textEditingController,
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                              cursorErrorColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              maxLines: controller.maxLines.value,
                              minLines: controller.maxLines.value,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                hintText: controller
                                    .languageServices
                                    .language
                                    .value
                                    .enterLocationOtherAddress,
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
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
                            SizedBox(height: 8),
                            ReactiveTextField(
                              style: controller
                                  .typographyServices
                                  .captionLargeRegular
                                  .value,
                              cursorErrorColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              formControlName: 'address_notes',
                              onTap: (control) async {},
                              onChanged: (control) {
                                if (control.value == "") {
                                  controller.addressNotes.value = null;
                                  return;
                                }
                                controller.addressNotes.value = control.value
                                    .toString();
                                controller.refreshIsFormValid();
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    controller.addressNotes.value == null
                                    ? EdgeInsets.zero
                                    : EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                hintText: "+ Tambah patokan lokasi",
                                hintStyle: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey400
                                          .value,
                                    ),
                                errorStyle: controller
                                    .typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorRed500
                                          .value,
                                    ),
                                focusedErrorBorder:
                                    controller.addressNotes.value == null
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                        ),
                                      ),
                                errorBorder:
                                    controller.addressNotes.value == null
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorRed500
                                              .value,
                                        ),
                                      ),
                                enabledBorder:
                                    controller.addressNotes.value == null
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                border: controller.addressNotes.value == null
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                focusedBorder:
                                    controller.addressNotes.value == null
                                    ? InputBorder.none
                                    : OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (error) =>
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .requiredFields ??
                                    "-",
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2),
                                  if (controller.geocodingPlaceList.isEmpty &&
                                      controller.keyword.value != '' &&
                                      controller.isFetchAddressSearch.value ==
                                          false) ...[
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/img_location_not_found.png",
                                            width: 72,
                                            height: 72,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .locationNotFound ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallBold
                                                .value
                                                .copyWith(),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .makesureAddressCorrect ??
                                                '-',
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  for (var geocodingPlace
                                      in controller.geocodingPlaceList) ...[
                                    GestureDetector(
                                      onTap: () {
                                        controller.textEditingController.text =
                                            geocodingPlace.address ?? "-";
                                        controller.formGroup
                                                .control("address_detail")
                                                .value =
                                            geocodingPlace.address ?? "-";
                                        controller.maxLines.value = 3;
                                        controller.geocodingPlace.value =
                                            geocodingPlace;
                                        controller.geocodingPlaceList.value =
                                            [];
                                        controller.keyword.value = '';
                                        FocusScope.of(context).unfocus();
                                        controller.refreshIsFormValid();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 14,
                                          bottom: 14,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_pinpoint.svg",
                                                    width: 13.5,
                                                    height: 15.75,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          controller
                                                              .themeColorServices
                                                              .primaryBlue
                                                              .value,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextHighlight(
                                                    text:
                                                        geocodingPlace.name ??
                                                        "-",
                                                    words: controller
                                                        .highlightedWordTitleAddress,
                                                    textStyle: controller
                                                        .typographyServices
                                                        .bodySmallBold
                                                        .value,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  SizedBox(height: 4),
                                                  TextHighlight(
                                                    text:
                                                        geocodingPlace
                                                                .customDistanceM !=
                                                            null
                                                        ? "${controller.getDistanceString(geocodingPlace: geocodingPlace)} ⬩ ${geocodingPlace.address}"
                                                        : geocodingPlace
                                                              .address!,
                                                    words: controller
                                                        .highlightedWordAddress,
                                                    textStyle: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value,
                                                  ),
                                                ],
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
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ],
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: Color(0XFFCDE2F8),
          color: Color(0XFFCDE2F8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: controller.isFormValid.value == false
                    ? null
                    : () async {
                        await controller.onTapSaveAddress();
                      },
                child: Text(
                  controller.languageServices.language.value.saveAddress ?? "-",
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
