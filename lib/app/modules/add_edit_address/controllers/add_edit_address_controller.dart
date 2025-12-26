import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/google_place_text_search_model.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddEditAddressController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final formKey = GlobalKey<FormState>();

  final formGroup = FormGroup({
    "address_name": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "address": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
  });

  final googlePlaceTextSearch = GooglePlaceTextSearch().obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    googlePlaceTextSearch.value =
        Get.arguments['google_place_text_search'] ?? GooglePlaceTextSearch();
    formGroup.control("address").value =
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
}
