import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/data/models/recommendation_location_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/service_area_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';

import '../../../routes/app_pages.dart';

class CreateOrderRideController extends GetxController {
  final GeocodingRepository geocodingRepository;
  final SavedAddressRepository savedAddressRepository;
  final OrderRideRepository orderRideRepository;

  CreateOrderRideController({
    required this.geocodingRepository,
    required this.savedAddressRepository,
    required this.orderRideRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  // Form
  final originTextEditingController = TextEditingController();
  final focusNodeOrigin = FocusNode();
  final isOriginHasPrimaryFocus = false.obs;
  final originLatitude = "".obs;
  final originLongitude = "".obs;
  final originAddressName = "".obs;
  final originAddress = "".obs;
  final keywordOrigin = "".obs;

  final destinationTextEditingController = TextEditingController();
  final focusNodeDestination = FocusNode();
  final isDestinationHasPrimaryFocus = false.obs;
  final destinationLatitude = "".obs;
  final destinationLongitude = "".obs;
  final destinationAddressName = "".obs;
  final destinationAddress = "".obs;
  final keywordDestination = "".obs;

  final originGeocodingPlace = GeocodingPlace().obs;
  final destinationGeocodingPlace = GeocodingPlace().obs;

  // Recommendation
  final savedAddressList = <SavedAddress>[].obs;
  final historyOrderList = <HistoryOrder>[].obs;
  final recommendationCurrentLocationList = <RecommendationLocation>[].obs;
  final recommendationOriginLocationList = <RecommendationLocation>[].obs;
  final recommendationDestinationLocationList = <RecommendationLocation>[].obs;
  final originGeocodingPlaceList = <GeocodingPlace>[].obs;
  final destinationGeocodingPlaceList = <GeocodingPlace>[].obs;

  // My Location
  final currentLatitude = Rx<String?>(null);
  final currentLongitude = Rx<String?>(null);
  final isPermissionLocationAllow = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await requestLocation();
    await Future.wait([getSavedAddressList(), getHistoryOrderList()]);
    isOriginHasPrimaryFocus.value = true;
    isDestinationHasPrimaryFocus.value = false;

    focusNodeOrigin.addListener(() {
      isOriginHasPrimaryFocus.value = focusNodeOrigin.hasPrimaryFocus;
      isOriginHasPrimaryFocus.refresh();
    });

    focusNodeDestination.addListener(() {
      isDestinationHasPrimaryFocus.value = focusNodeDestination.hasPrimaryFocus;
      isDestinationHasPrimaryFocus.refresh();
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

  Future<void> getSavedAddressList() async {
    savedAddressList.value = (await savedAddressRepository
        .getSavedAddressList());
  }

  Future<void> getHistoryOrderList() async {
    historyOrderList.value = (await orderRideRepository.getHistoryOrderList(
      language: languageServices.languageCodeSystem.value,
      pageNum: 1,
      size: 3,
      type: 1,
    ));

    for (var historyOrigin in historyOrderList) {
      var orderDetail = await orderRideRepository.getOrderRideDetailbyOrderId(
        orderId: historyOrigin.orderId.toString(),
        orderType: historyOrigin.orderType!,
        language: languageServices.languageCodeSystem.value,
      );

      var recommendationOriginLocation = RecommendationLocation(
        id: "${historyOrigin.startAddress}",
        name: orderDetail.startAddressName,
        addressDetail: historyOrigin.startAddress,
        latitude: orderDetail.startLat.toString(),
        longitude: orderDetail.startLon.toString(),
      );
      var recommendationDestinationLocation = RecommendationLocation(
        id: "${historyOrigin.endAddress}",
        name: orderDetail.endAddressName,
        addressDetail: historyOrigin.endAddress,
        latitude: orderDetail.endLat.toString(),
        longitude: orderDetail.endLon.toString(),
      );

      if (recommendationOriginLocation.name == "" ||
          recommendationOriginLocation.name == null) {
        recommendationOriginLocation.name =
            (await geocodingRepository.getAddressByLatitudeLongitude(
              latitude: orderDetail.startLat,
              longitude: orderDetail.startLon,
            ))?.name ??
            "-";
      }
      if (recommendationDestinationLocation.name == "" ||
          recommendationDestinationLocation.name == null) {
        recommendationDestinationLocation.name =
            (await geocodingRepository.getAddressByLatitudeLongitude(
              latitude: orderDetail.endLat,
              longitude: orderDetail.endLon,
            ))?.name ??
            "-";
      }

      var isRecommendationOriginExists = recommendationOriginLocationList.any(
        (e) => e.id == recommendationOriginLocation.id,
      );
      if (isRecommendationOriginExists == false) {
        if (currentLatitude.value != null) {
          var distanceMeter = Geolocator.distanceBetween(
            double.parse(currentLatitude.value!),
            double.parse(currentLongitude.value!),
            double.parse(recommendationOriginLocation.latitude!),
            double.parse(recommendationOriginLocation.longitude!),
          );
          var distanceKm = (distanceMeter / 1000);

          recommendationOriginLocation.customDistanceKm = distanceKm;
          recommendationOriginLocation.customDistanceM = distanceMeter;
        }
        recommendationOriginLocationList.add(recommendationOriginLocation);
      }

      var isRecommendationDesinationExists =
          recommendationDestinationLocationList.any(
            (e) => e.id == recommendationDestinationLocation.id,
          );
      if (isRecommendationDesinationExists == false) {
        if (currentLatitude.value != null) {
          var distanceMeter = Geolocator.distanceBetween(
            double.parse(currentLatitude.value!),
            double.parse(currentLongitude.value!),
            double.parse(recommendationDestinationLocation.latitude!),
            double.parse(recommendationDestinationLocation.longitude!),
          );
          var distanceKm = (distanceMeter / 1000);

          recommendationDestinationLocation.customDistanceKm = distanceKm;
          recommendationDestinationLocation.customDistanceM = distanceMeter;
        }

        recommendationDestinationLocationList.add(
          recommendationDestinationLocation,
        );
      }
    }
  }

  Future<void> requestLocation() async {
    isPermissionLocationAllow.value = true;
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      isPermissionLocationAllow.value = false;
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

    focusNodeOrigin.requestFocus();

    if (currentLatitude.value != null) {
      var geocodingAddress =
          (await geocodingRepository.getAddressByLatitudeLongitude(
            latitude: double.parse(currentLatitude.value!),
            longitude: double.parse(currentLongitude.value!),
          )) ??
          GeocodingAddress();
      var currentLocationDetail = geocodingAddress.address;

      recommendationCurrentLocationList.value = [];
      if (currentLocationDetail != null) {
        recommendationCurrentLocationList.add(
          RecommendationLocation(
            name: geocodingAddress.name,
            id: currentLocationDetail,
            latitude: currentLatitude.value,
            longitude: currentLongitude.value,
            addressDetail: currentLocationDetail,
          ),
        );
      }
    }
  }

  Future<void> getOriginPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      if (keywordOrigin.value == keyword) {
        originGeocodingPlaceList.value = await geocodingRepository
            .getGeocodingPlaceByQuery(limit: 5, query: keywordOrigin.value);

        print(originGeocodingPlaceList);

        if (currentLatitude.value != null) {
          for (var location in originGeocodingPlaceList) {
            var distanceMeter = Geolocator.distanceBetween(
              double.parse(currentLatitude.value!),
              double.parse(currentLongitude.value!),
              location.lat!,
              location.lng!,
            );
            var distanceKm = (distanceMeter / 1000);

            location.customDistanceKm = distanceKm;
            location.customDistanceM = distanceMeter;
          }

          originGeocodingPlaceList.sort(
            (a, b) => a.customDistanceM!.compareTo(b.customDistanceM!),
          );

          originGeocodingPlaceList.refresh();
        }
      }
    });
  }

  Future<void> getDestinationPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      if (keywordDestination.value == keyword) {
        destinationGeocodingPlaceList.value = await geocodingRepository
            .getGeocodingPlaceByQuery(
              limit: 5,
              query: keywordDestination.value,
            );

        if (currentLatitude.value != null) {
          for (var location in destinationGeocodingPlaceList) {
            var distanceMeter = Geolocator.distanceBetween(
              double.parse(currentLatitude.value!),
              double.parse(currentLongitude.value!),
              location.lat!,
              location.lng!,
            );
            var distanceKm = (distanceMeter / 1000);

            location.customDistanceKm = distanceKm;
            location.customDistanceM = distanceMeter;
          }

          destinationGeocodingPlaceList.sort(
            (a, b) => a.customDistanceM!.compareTo(b.customDistanceM!),
          );

          destinationGeocodingPlaceList.refresh();
        }
      }
    });
  }

  bool isLatLngOriginFilled() {
    return originLatitude.value != "" && originLongitude.value != "";
  }

  bool isLatLngDestinationFilled() {
    return destinationLatitude.value != "" && destinationLongitude.value != "";
  }

  Future<void> fillOriginBySavedAddress({
    required SavedAddress savedAddress,
  }) async {
    originTextEditingController.text = savedAddress.addressDetail!;
    originLatitude.value = savedAddress.latitude!;
    originLongitude.value = savedAddress.longitude!;
    keywordOrigin.value = savedAddress.addressTitle!;
    originAddress.value = savedAddress.addressDetail!;

    await getOriginPlaceLocationList(keyword: keywordOrigin.value);
  }

  Future<void> fillDestinationBySavedAddress({
    required SavedAddress savedAddress,
  }) async {
    destinationTextEditingController.text = savedAddress.addressDetail!;
    destinationLatitude.value = savedAddress.latitude!;
    destinationLongitude.value = savedAddress.longitude!;
    keywordDestination.value = savedAddress.addressTitle!;
    destinationAddress.value = savedAddress.addressDetail!;

    await getDestinationPlaceLocationList(keyword: keywordDestination.value);
  }

  Future<void> onTapSavedLocation({required SavedAddress savedAddress}) async {
    if (isLatLngOriginFilled() == false) {
      await fillOriginBySavedAddress(savedAddress: savedAddress);

      focusNodeDestination.requestFocus();
    } else if (isLatLngDestinationFilled() == false) {
      await fillDestinationBySavedAddress(savedAddress: savedAddress);

      focusNodeDestination.requestFocus();
    }
  }

  // Origin
  Future<void> onTapOriginCurrentLocation() async {
    var selectedCurrentLocation = recommendationCurrentLocationList.first;

    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: double.parse(selectedCurrentLocation.latitude!),
      longitude: double.parse(selectedCurrentLocation.longitude!),
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }

    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "origin",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.addressDetail ?? "-",
        "latitude": selectedCurrentLocation.latitude!.toString(),
        "longitude": selectedCurrentLocation.longitude!.toString(),
      },
    );

    if (result != null) {
      originLatitude.value = result['latitude'];
      originLongitude.value = result['longitude'];
      originAddressName.value = result['address_name'];
      originAddress.value = result['address'];
      keywordOrigin.value = result['address_name'];
      originTextEditingController.text = result['address_name'];

      await Future.delayed(Duration(milliseconds: 100));
      focusNodeDestination.requestFocus();
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = true;

      await getOriginPlaceLocationList(keyword: originAddressName.value);
    }
  }

  Future<void> onTapOriginSearchedLocation({
    required GeocodingPlace selectedCurrentLocation,
  }) async {
    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: selectedCurrentLocation.lat!,
      longitude: selectedCurrentLocation.lng!,
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }

    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "origin",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.address ?? "-",
        "latitude": selectedCurrentLocation.lat.toString(),
        "longitude": selectedCurrentLocation.lng.toString(),
      },
    );

    if (result != null) {
      originLatitude.value = result['latitude'].toString();
      originLongitude.value = result['longitude'].toString();
      originAddressName.value = result['address_name'];
      originAddress.value = result['address'];
      keywordOrigin.value = result['address_name'];
      originTextEditingController.text = result['address_name'];

      await Future.delayed(Duration(milliseconds: 100));
      focusNodeDestination.requestFocus();
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = true;
      await getOriginPlaceLocationList(keyword: originAddressName.value);
    }
  }

  Future<void> onTapOriginLatestOrderLocation({
    required RecommendationLocation selectedCurrentLocation,
  }) async {
    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: double.parse(selectedCurrentLocation.latitude!),
      longitude: double.parse(selectedCurrentLocation.longitude!),
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }

    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "origin",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.addressDetail ?? "-",
        "latitude": selectedCurrentLocation.latitude.toString(),
        "longitude": selectedCurrentLocation.longitude.toString(),
      },
    );

    if (result != null) {
      originLatitude.value = result['latitude'];
      originLongitude.value = result['longitude'];
      originAddressName.value = result['address_name'];
      originAddress.value = result['address'];
      keywordOrigin.value = result['address_name'];
      originTextEditingController.text = result['address_name'];

      await Future.delayed(Duration(milliseconds: 100));
      focusNodeDestination.requestFocus();
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = true;
      await getOriginPlaceLocationList(keyword: originAddressName.value);
    }
  }

  // Destination
  Future<void> onTapDestinationCurrentLocation() async {
    var selectedCurrentLocation = recommendationCurrentLocationList.first;

    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: double.parse(selectedCurrentLocation.latitude!),
      longitude: double.parse(selectedCurrentLocation.longitude!),
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }

    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "destination",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.addressDetail ?? "-",
        "latitude": selectedCurrentLocation.latitude!.toString(),
        "longitude": selectedCurrentLocation.longitude!.toString(),
      },
    );

    if (result != null) {
      destinationLatitude.value = result['latitude'];
      destinationLongitude.value = result['longitude'];
      destinationAddressName.value = result['address_name'];
      destinationAddress.value = result['address'];
      keywordDestination.value = result['address_name'];
      destinationTextEditingController.text = result['address_name'];
      await getDestinationPlaceLocationList(
        keyword: destinationAddressName.value,
      );

      await onTapSubmit();
    }
  }

  Future<void> onTapDestinationSearchedLocation({
    required GeocodingPlace selectedCurrentLocation,
  }) async {
    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: selectedCurrentLocation.lat!,
      longitude: selectedCurrentLocation.lng!,
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }

    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "destination",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.address ?? "-",
        "latitude": selectedCurrentLocation.lat!.toString(),
        "longitude": selectedCurrentLocation.lng!.toString(),
      },
    );

    if (result != null) {
      destinationLatitude.value = result['latitude'].toString();
      destinationLongitude.value = result['longitude'].toString();
      destinationAddressName.value = result['address_name'];
      destinationAddress.value = result['address'];
      keywordDestination.value = result['address_name'];
      destinationTextEditingController.text = result['address_name'];
      await getDestinationPlaceLocationList(
        keyword: destinationAddressName.value,
      );

      await onTapSubmit();
    }
  }

  Future<void> onTapDestinationLatestOrderLocation({
    required RecommendationLocation selectedCurrentLocation,
  }) async {
    var isInsideserviceArea = isLatLngInsideServiceArea(
      latitude: double.parse(selectedCurrentLocation.latitude!),
      longitude: double.parse(selectedCurrentLocation.longitude!),
    );
    if (isInsideserviceArea == false) {
      SnackbarHelper.showSnackbarError(
        text: 'Alamat diluar wilayah layanan tersedia',
      );
      return;
    }
    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {
        "type": "destination",
        "address_name": selectedCurrentLocation.name ?? "-",
        "address": selectedCurrentLocation.addressDetail ?? "-",
        "latitude": selectedCurrentLocation.latitude!.toString(),
        "longitude": selectedCurrentLocation.longitude!.toString(),
      },
    );

    if (result != null) {
      destinationLatitude.value = result['latitude'];
      destinationLongitude.value = result['longitude'];
      destinationAddressName.value = result['address_name'];
      destinationAddress.value = result['address'];
      keywordDestination.value = result['address_name'];
      destinationTextEditingController.text = result['address_name'];
      await getDestinationPlaceLocationList(
        keyword: destinationAddressName.value,
      );

      await onTapSubmit();
    }
  }

  Future<void> onTapOriginMapSelect() async {
    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {"type": "origin"},
    );

    if (result != null) {
      originLatitude.value = result['latitude'];
      originLongitude.value = result['longitude'];
      originAddressName.value = result['address_name'];
      originAddress.value = result['address'];
      keywordOrigin.value = result['address_name'];
      originTextEditingController.text = result['address_name'];

      await Future.delayed(Duration(milliseconds: 100));
      focusNodeDestination.requestFocus();
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = true;

      await getOriginPlaceLocationList(keyword: originAddressName.value);
    }
  }

  Future<void> onTapDestinationMapSelect() async {
    var result = await Get.toNamed(
      Routes.CREATE_ORDER_RIDE_MAP_SELECT,
      arguments: {"type": "destination"},
    );

    if (result != null) {
      destinationLatitude.value = result['latitude'];
      destinationLongitude.value = result['longitude'];
      destinationAddressName.value = result['address_name'];
      destinationAddress.value = result['address'];
      keywordDestination.value = result['address_name'];
      destinationTextEditingController.text = result['address_name'];
      await getDestinationPlaceLocationList(
        keyword: destinationAddressName.value,
      );
      await onTapSubmit();
    }
  }

  Future<void> onTapSubmit() async {
    Get.toNamed(
      Routes.CREATE_ORDER_RIDE_CHECKOUT,
      arguments: {
        "origin_address_name": originAddressName.value,
        "origin_address": originAddress.value,
        "origin_latitude": originLatitude.value,
        "origin_longitude": originLongitude.value,
        "destination_address_name": destinationAddressName.value,
        "destination_address": destinationAddress.value,
        "destination_latitude": destinationLatitude.value,
        "destination_longitude": destinationLongitude.value,
      },
    );
  }
}
