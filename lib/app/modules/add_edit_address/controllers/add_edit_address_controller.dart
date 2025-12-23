import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/google_place_text_search_model.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddEditAddressController extends GetxController {
  final SavedAddressRepository savedAddressRepository;

  AddEditAddressController({required this.savedAddressRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final formKey = GlobalKey<FormState>();

  final formGroup = FormGroup({
    "address_name": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "address_detail": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
  });

  final googlePlaceTextSearch = GooglePlaceTextSearch().obs;
  final addressType = 0.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    googlePlaceTextSearch.value =
        Get.arguments['google_place_text_search'] ?? GooglePlaceTextSearch();
    addressType.value = Get.arguments['address_type'] ?? 0;
    formGroup.control("address_detail").value =
        googlePlaceTextSearch.value.formattedAddress;
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

  Future<void> onTapSaveAddress() async {
    try {
      formGroup.markAllAsTouched();

      if (formGroup.valid) {
        await savedAddressRepository.insertSavedAddress(
          addressName: formGroup.control("address_name").value,
          addressTitle: googlePlaceTextSearch.value.name ?? "",
          addressDetail: formGroup.control("address_detail").value,
          latitude: googlePlaceTextSearch.value.geometry!.location!.lat
              .toString(),
          longitude: googlePlaceTextSearch.value.geometry!.location!.lng
              .toString(),
          addressType: addressType.value,
        );

        Get.back();
        Get.back();

        var snackBar = SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: themeColorServices.sematicColorGreen400.value,
          content: Text(
            "Berhasil menambah alamat",
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        );
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    } catch (e) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }
}
