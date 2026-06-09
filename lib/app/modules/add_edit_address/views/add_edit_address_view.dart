import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/add_edit_address_controller.dart';

class AddEditAddressView extends GetView<AddEditAddressController> {
  const AddEditAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.languageServices.language.value.locationDetails ?? "-",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        surfaceTintColor:
            controller.themeColorServices.neutralsColorGrey0.value,
      ),
      body: Stack(
        clipBehavior: Clip.none,
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey200
                              .value,
                        ),
                      ),
                      child: ReactiveForm(
                        formGroup: controller.formGroup,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .locationName ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "*",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
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
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .enterLocation ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "*",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
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
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var geocodingPlace = await Get.toNamed(
                                        Routes.SEARCH_ADDRESS,
                                        preventDuplicates: false,
                                        arguments: {
                                          "tag": DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                        },
                                      );

                                      if (geocodingPlace != null) {
                                        controller.geocodingPlace.value =
                                            geocodingPlace;

                                        controller.formGroup
                                                .control("address_detail")
                                                .value =
                                            geocodingPlace.address;
                                      }
                                    },
                                    child: Text(
                                      controller.formGroup
                                          .control("address_detail")
                                          .value,
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ReactiveTextField(
                                    readOnly: false,
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
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      hintText: controller
                                          .languageServices
                                          .language
                                          .value
                                          .addBenchmark,
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
    );
  }
}
