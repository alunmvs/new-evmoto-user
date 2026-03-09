import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class SearchAddressController extends GetxController {
  final GeocodingRepository geocodingRepository;

  SearchAddressController({required this.geocodingRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final addressType = 0.obs;
  final keyword = "".obs;
  late TextEditingController textEditingController;

  final highlightedWordTitleAddress = <String, HighlightedWord>{}.obs;
  final highlightedWordAddress = <String, HighlightedWord>{}.obs;
  final isDisplaySearchAddressPinnedTop = false.obs;

  // final googlePlaceTextSearchList = <GooglePlaceTextSearch>[].obs;
  final geocodingPlaceList = <GeocodingPlace>[].obs;
  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final isEdit = false.obs;

  final isFetch = false.obs;
  final isFetchAddressSearch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await requestLocation();

    if (Get.arguments?['address_type'] == null) {
      isEdit.value = true;
    } else {
      addressType.value = Get.arguments['address_type'] ?? "";
    }
    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      keyword.value = textEditingController.text;
      highlightedWordTitleAddress.clear();
      highlightedWordAddress.clear();
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

  Future<void> requestLocation() async {
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      return;
    }

    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    currentLatitude.value = position.latitude.toString();
    currentLongitude.value = position.longitude.toString();
  }

  Future<void> getPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      isFetchAddressSearch.value = true;
      if (this.keyword.value == '') {
        geocodingPlaceList.value = [];
      }
      if (this.keyword.value == keyword && this.keyword.value != '') {
        geocodingPlaceList.value = await geocodingRepository
            .getGeocodingPlaceByQuery(limit: 5, query: this.keyword.value);

        for (var location in geocodingPlaceList) {
          var distanceMeter = Geolocator.distanceBetween(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
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
                  textStyle: typographyServices.captionLargeBold.value.copyWith(
                    color: themeColorServices.neutralsColorGrey500.value,
                  ),
                );
          } else {
            highlightedWordAddress["${distanceKm.toStringAsFixed(2)} ${languageServices.language.value.km} ⬩ "] =
                HighlightedWord(
                  onTap: () {},
                  textStyle: typographyServices.captionLargeBold.value.copyWith(
                    color: themeColorServices.neutralsColorGrey500.value,
                  ),
                );
          }
        }
        isFetchAddressSearch.value = false;
      }
    });
  }

  String getDistanceString({required GeocodingPlace geocodingPlace}) {
    if (geocodingPlace.customDistanceKm! < 1) {
      return "${geocodingPlace.customDistanceM!.round()} m";
    } else {
      return "${geocodingPlace.customDistanceKm!.toStringAsFixed(2)} ${languageServices.language.value.km}";
    }
  }
}
