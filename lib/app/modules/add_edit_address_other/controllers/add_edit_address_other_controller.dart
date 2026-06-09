import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/controllers/setting_saved_location_controller.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../routes/app_pages.dart';

class AddEditAddressOtherController extends GetxController {
  final SavedAddressRepository savedAddressRepository;
  final GeocodingRepository geocodingRepository;

  AddEditAddressOtherController({
    required this.savedAddressRepository,
    required this.geocodingRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final locationServices = Get.find<LocationServices>();

  final formKey = GlobalKey<FormState>();

  final formGroup = FormGroup({
    "address_name": FormControl<String>(
      validators: <Validator>[Validators.required, Validators.maxLength(50)],
    ),
    "address_detail": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "address_notes": FormControl<String>(validators: <Validator>[]),
  });

  final geocodingPlace = GeocodingPlace().obs;
  final addressType = 3.obs;

  final savedAddress = SavedAddress().obs;
  final isEdit = false.obs;

  final keyword = "".obs;
  late TextEditingController textEditingController;

  final highlightedWordTitleAddress = <String, HighlightedWord>{}.obs;
  final highlightedWordAddress = <String, HighlightedWord>{}.obs;
  final isDisplaySearchAddressPinnedTop = false.obs;

  final geocodingPlaceList = <GeocodingPlace>[].obs;

  final isFetch = false.obs;
  final isFetchAddressSearch = false.obs;
  final maxLines = 1.obs;

  final addressNotes = Rx<String?>(null);
  final isFormValid = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;

    textEditingController = TextEditingController();

    if (Get.arguments?['saved_address'] != null) {
      isEdit.value = true;
      savedAddress.value = Get.arguments['saved_address'];

      addressType.value = savedAddress.value.addressType!;
      formGroup.control("address_detail").value =
          savedAddress.value.addressDetail!;
      formGroup.control("address_name").value = savedAddress.value.addressName!;
      formGroup.control("address_notes").value =
          savedAddress.value.addressNotes;
      textEditingController.text = savedAddress.value.addressDetail!;
      maxLines.value = 3;
      geocodingPlace.value = GeocodingPlace(
        lat: double.tryParse(savedAddress.value.latitude!),
        lng: double.tryParse(savedAddress.value.longitude!),
        address: savedAddress.value.addressDetail,
        name: savedAddress.value.addressName,
      );
      refreshIsFormValid();
    }

    textEditingController.addListener(() {
      keyword.value = textEditingController.text;
      highlightedWordTitleAddress.clear();
      highlightedWordAddress.clear();
      geocodingPlace.value = GeocodingPlace();
      maxLines.value = 1;
      formGroup.control("address_detail").value = null;

      for (var word in keyword.value.split(" ")) {
        highlightedWordTitleAddress[word] = HighlightedWord(
          onTap: () {},
          textStyle: typographyServices.bodySmallBold.value.copyWith(
            color: themeColorServices.primaryBlue.value,
          ),
        );

        highlightedWordAddress[word] = HighlightedWord(
          onTap: () {},
          textStyle: typographyServices.captionLargeRegular.value.copyWith(
            color: themeColorServices.primaryBlue.value,
          ),
        );
      }

      highlightedWordTitleAddress.refresh();
      highlightedWordAddress.refresh();
      isDisplaySearchAddressPinnedTop.refresh();

      getPlaceLocationList(keyword: keyword.value);
    });
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
        if (isEdit.value == false) {
          await savedAddressRepository.insertSavedAddress(
            addressName: formGroup.control("address_name").value,
            addressTitle: geocodingPlace.value.name ?? "",
            addressDetail: formGroup.control("address_detail").value,
            addressNotes: formGroup.control("address_notes").value,
            latitude: geocodingPlace.value.lat.toString(),
            longitude: geocodingPlace.value.lng.toString(),
            addressType: addressType.value,
          );

          Get.back();

          if (Get.currentRoute == Routes.SETTING_SAVED_LOCATION) {
            await Get.find<SettingSavedLocationController>()
                .getSavedAddressList();
          }
          SnackbarHelper.showSnackbarSuccess(
            text:
                languageServices.language.value.successfullySavedAddress ?? "-",
          );
        } else {
          await savedAddressRepository.updateSavedAddress(
            id: savedAddress.value.id!,
            addressName: formGroup.control("address_name").value,
            addressTitle:
                geocodingPlace.value.name ?? savedAddress.value.addressTitle!,
            addressDetail: formGroup.control("address_detail").value,
            addressNotes: formGroup.control("address_notes").value,
            latitude: (geocodingPlace.value.lat ?? savedAddress.value.latitude!)
                .toString(),
            longitude:
                (geocodingPlace.value.lng ?? savedAddress.value.longitude!)
                    .toString(),
            addressType: addressType.value,
          );

          Get.back();

          if (Get.currentRoute == Routes.SETTING_SAVED_LOCATION) {
            await Get.find<SettingSavedLocationController>()
                .getSavedAddressList();
          }
          SnackbarHelper.showSnackbarSuccess(
            text:
                languageServices.language.value.snackbarAddressEditSuccess ??
                "-",
          );
        }
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  String getDistanceString({required GeocodingPlace geocodingPlace}) {
    if (geocodingPlace.customDistanceKm! < 1) {
      return "${geocodingPlace.customDistanceM!.round()} m";
    } else {
      return "${geocodingPlace.customDistanceKm!.toStringAsFixed(2)} ${languageServices.language.value.km}";
    }
  }

  Future<void> getPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      isFetchAddressSearch.value = true;
      if (this.keyword.value == '') {
        geocodingPlaceList.value = [];
      }
      if (this.keyword.value == keyword && this.keyword.value != '') {
        try {
          geocodingPlaceList.value = await geocodingRepository
              .getGeocodingPlaceByQuery(limit: 5, query: this.keyword.value);

          if (locationServices.currentLatitude.value != null) {
            for (var location in geocodingPlaceList) {
              var distanceMeter = Geolocator.distanceBetween(
                locationServices.currentLatitude.value!,
                locationServices.currentLongitude.value!,
                location.lat!,
                location.lng!,
              );
              var distanceKm = (distanceMeter / 1000);

              location.customDistanceKm = distanceKm;
              location.customDistanceM = distanceMeter;

              if (distanceKm < 1) {
                highlightedWordAddress["${distanceMeter.round()} m ⬩"] =
                    HighlightedWord(
                      onTap: () {},
                      textStyle: typographyServices.captionLargeBold.value
                          .copyWith(
                            color:
                                themeColorServices.neutralsColorGrey500.value,
                          ),
                    );
              } else {
                highlightedWordAddress["${distanceKm.toStringAsFixed(2)} ${languageServices.language.value.km} ⬩ "] =
                    HighlightedWord(
                      onTap: () {},
                      textStyle: typographyServices.captionLargeBold.value
                          .copyWith(
                            color:
                                themeColorServices.neutralsColorGrey500.value,
                          ),
                    );
              }
            }
          }
        } on DioException catch (e) {
          SnackbarHelper.showSnackbarError(text: e.error.toString());
        } on Exception catch (e) {
          SnackbarHelper.showSnackbarError(text: e.toString());
        }
        isFetchAddressSearch.value = false;
      }
    });
  }

  void refreshIsFormValid() {
    isFormValid.value = formGroup.valid && geocodingPlace.value.address != null;
  }
}
