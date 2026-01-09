import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/data/models/google_place_text_search_model.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class SearchAddressController extends GetxController {
  final GoogleMapsRepository googleMapsRepository;

  SearchAddressController({required this.googleMapsRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final addressType = 0.obs;
  final keyword = "".obs;
  late TextEditingController textEditingController;

  final highlightedWordTitleAddress = <String, HighlightedWord>{}.obs;
  final highlightedWordAddress = <String, HighlightedWord>{}.obs;
  final isDisplaySearchAddressPinnedTop = false.obs;

  final googlePlaceTextSearchList = <GooglePlaceTextSearch>[].obs;
  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final isEdit = false.obs;

  final isFetch = false.obs;

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
      if (this.keyword.value == keyword) {
        googlePlaceTextSearchList.value = await googleMapsRepository
            .getRecommendationPlaceListByTextSearch(
              query: this.keyword.value,
              language: "en",
            );

        for (var location in googlePlaceTextSearchList) {
          var distanceMeter = Geolocator.distanceBetween(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
            location.geometry!.location!.lat!,
            location.geometry!.location!.lng!,
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
      }
    });
  }

  String getDistanceString({
    required GooglePlaceTextSearch googlePlaceTextSearch,
  }) {
    if (googlePlaceTextSearch.customDistanceKm! < 1) {
      return "${googlePlaceTextSearch.customDistanceM!.round()} m";
    } else {
      return "${googlePlaceTextSearch.customDistanceKm!.toStringAsFixed(2)} ${languageServices.language.value.km}";
    }
  }
}
