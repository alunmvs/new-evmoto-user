import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/google_geo_code_search_model.dart';
import 'package:new_evmoto_user/app/data/models/google_place_text_search_model.dart';
import 'package:new_evmoto_user/app/data/models/history_order_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/data/models/recommendation_location_model.dart';
import 'package:new_evmoto_user/app/data/models/requested_order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

class RideController extends GetxController {
  final GoogleMapsRepository googleMapsRepository;
  final OrderRideRepository orderRideRepository;
  final SavedAddressRepository savedAddressRepository;

  RideController({
    required this.googleMapsRepository,
    required this.orderRideRepository,
    required this.savedAddressRepository,
  });

  final homeController = Get.find<HomeController>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final originTextEditingController = TextEditingController();
  final focusNodeOrigin = FocusNode();
  final originGooglePlaceTextSearch = GooglePlaceTextSearch().obs;
  final originLatitude = "".obs;
  final originLongitude = "".obs;
  final originAddress = "".obs;

  final destinationTextEditingController = TextEditingController();
  final focusNodeDestination = FocusNode();
  final destinationGooglePlaceTextSearch = GooglePlaceTextSearch().obs;
  final destinationLatitude = "".obs;
  final destinationLongitude = "".obs;
  final destinationAddress = "".obs;

  final originGoogleGeoCodeSearch = GoogleGeoCodeSearch().obs;
  final destinationGoogleGeoCodeSearch = GoogleGeoCodeSearch().obs;
  final originSearchLatitude = "".obs;
  final originSearchLongitude = "".obs;
  final destinationSearchLatitude = "".obs;
  final destinationSearchLongitude = "".obs;
  final originSearchIsLoading = false.obs;
  final destinationSearchIsLoading = false.obs;

  final isHideMarkersAndPolylines = false.obs;

  final keywordOrigin = "".obs;
  late TextEditingController textEditingControllerOrigin;

  final highlightedWordTitleAddressOrigin = <String, HighlightedWord>{}.obs;
  final highlightedWordAddressOrigin = <String, HighlightedWord>{}.obs;

  final keywordDestination = "".obs;
  late TextEditingController textEditingControllerDestination;

  final highlightedWordTitleAddressDestination =
      <String, HighlightedWord>{}.obs;
  final highlightedWordAddressDestination = <String, HighlightedWord>{}.obs;

  final isOriginHasPrimaryFocus = false.obs;
  final isDestinationHasPrimaryFocus = false.obs;

  final selectedPaymentMethod = "ecgo_wallet".obs;

  final status = "fill_origin_and_destination".obs;

  final fillOriginAndDestinationPanelController = PanelController();
  final fillOriginAndDestinationPanelMinHeight = 0.0.obs;
  final fillOriginAndDestinationPanelMaxHeight = 0.0.obs;

  final originGooglePlaceTextSearchList = <GooglePlaceTextSearch>[].obs;
  final destinationGooglePlaceTextSearchList = <GooglePlaceTextSearch>[].obs;

  final orderRidePricingList = <OrderRidePricing>[].obs;
  final selectedOrderRidePricing = OrderRidePricing().obs;
  final requestedOrderRide = RequestedOrderRide().obs;

  final historyOrderList = <HistoryOrder>[].obs;
  final recommendationOriginCurrentLocationList =
      <RecommendationLocation>[].obs;
  final recommendationOriginLocationList = <RecommendationLocation>[].obs;
  final recommendationDestinationLocationList = <RecommendationLocation>[].obs;

  final payType = 2.obs;
  final selectedCoupon = Coupon().obs;

  final savedAddressList = <SavedAddress>[].obs;
  final destinationSavedAddress = SavedAddress().obs;

  late Timer? orderStatusRefreshTimer;

  final estimatedTimeInMinutes = 0.0.obs;
  final estimatedDistanceInKm = 0.0.obs;
  final estimatedSpeedInKmh = 40.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;

    await homeController.getUserInfo();
    await Future.wait([getHistoryOrderList(), getSavedAddressList()]);
    await requestLocation();
    initialCameraPosition.value = CameraPosition(
      target: LatLng(
        double.parse(currentLatitude.value),
        double.parse(currentLongitude.value),
      ),
      zoom: 15,
    );

    fillOriginAndDestinationPanelMinHeight.value = Get.height * 0.8;
    fillOriginAndDestinationPanelMaxHeight.value = Get.height * 0.8;

    focusNodeOrigin.addListener(() {
      isOriginHasPrimaryFocus.value = focusNodeOrigin.hasPrimaryFocus;
      isOriginHasPrimaryFocus.refresh();
    });
    focusNodeDestination.addListener(() {
      isDestinationHasPrimaryFocus.value = focusNodeDestination.hasPrimaryFocus;
      isDestinationHasPrimaryFocus.refresh();
    });

    if (Get.arguments?['destination_saved_address'] != null) {
      destinationSavedAddress.value =
          Get.arguments['destination_saved_address'];
      await fillDestinationBySavedAddress(
        savedAddress: destinationSavedAddress.value,
      );
    }

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    try {
      googleMapController.dispose();
    } catch (e) {}
  }

  Future<void> getSavedAddressList() async {
    savedAddressList.value = (await savedAddressRepository
        .getSavedAddressList());
  }

  Future<void> onTapSavedLocation({required SavedAddress savedAddress}) async {
    if (isOriginHasPrimaryFocus.value == true) {
      await fillOriginBySavedAddress(savedAddress: savedAddress);

      focusNodeDestination.requestFocus();
    } else if (isDestinationHasPrimaryFocus.value == true) {
      await fillDestinationBySavedAddress(savedAddress: savedAddress);

      focusNodeDestination.requestFocus();
      status.value = "checkout";

      await Future.wait([
        generatePolylines(),
        refocusMapsBound(),
        getOrderRidePricingList(),
      ]);
      selectedOrderRidePricing.value = orderRidePricingList.first;
    }
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

    markers.removeWhere((m) => m.markerId.value == 'origin');
    markers.add(
      Marker(
        markerId: MarkerId("origin"),
        position: LatLng(
          double.parse(originLatitude.value),
          double.parse(originLongitude.value),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_origin.svg',
          Size(22.67, 22.67),
        ),
      ),
    );
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

    markers.removeWhere((m) => m.markerId.value == 'destination');
    markers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: LatLng(
          double.parse(destinationLatitude.value),
          double.parse(destinationLongitude.value),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint.svg',
          Size(27, 31),
        ),
      ),
    );
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
        addressDetail: historyOrigin.startAddress,
        latitude: orderDetail.startLat.toString(),
        longitude: orderDetail.startLon.toString(),
      );

      var isRecommendationOriginExists = recommendationOriginLocationList.any(
        (e) => e.id == recommendationOriginLocation.id,
      );

      if (isRecommendationOriginExists == false) {
        recommendationOriginLocationList.add(recommendationOriginLocation);
      }

      var recommendationDestinationLocation = RecommendationLocation(
        id: "${historyOrigin.endAddress}",
        addressDetail: historyOrigin.endAddress,
        latitude: orderDetail.endLat.toString(),
        longitude: orderDetail.endLon.toString(),
      );

      var isRecommendationDesinationExists =
          recommendationDestinationLocationList.any(
            (e) => e.id == recommendationDestinationLocation.id,
          );
      if (isRecommendationDesinationExists == false) {
        recommendationDestinationLocationList.add(
          recommendationDestinationLocation,
        );
      }
    }
  }

  Future<void> prefillOrderAgain() async {
    if (Get.arguments['start_address'] != null) {
      originTextEditingController.text = Get.arguments['start_address'] ?? "-";
      originLatitude.value = Get.arguments['start_lat'].toString();
      originLongitude.value = Get.arguments['start_lon'].toString();
      keywordOrigin.value = originTextEditingController.text;
      originAddress.value = originTextEditingController.text;

      markers.add(
        Marker(
          markerId: MarkerId("origin"),
          position: LatLng(
            double.parse(originLatitude.value),
            double.parse(originLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_origin.svg',
            Size(22.67, 22.67),
          ),
        ),
      );

      destinationTextEditingController.text =
          Get.arguments['end_address'] ?? "-";
      destinationLatitude.value = Get.arguments['end_lat'].toString();
      destinationLongitude.value = Get.arguments['end_lon'].toString();
      keywordDestination.value = destinationTextEditingController.text;
      destinationAddress.value = destinationTextEditingController.text;

      markers.add(
        Marker(
          markerId: MarkerId("destination"),
          position: LatLng(
            double.parse(destinationLatitude.value),
            double.parse(destinationLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_pinpoint.svg',
            Size(27, 31),
          ),
        ),
      );

      focusNodeDestination.requestFocus();

      await Future.wait([
        getOriginPlaceLocationList(keyword: originAddress.value),
        getDestinationPlaceLocationList(keyword: destinationAddress.value),
        generatePolylines(),
        refocusMapsBound(),
        getOrderRidePricingList(),
      ]);

      selectedOrderRidePricing.value = orderRidePricingList.first;

      status.value = "checkout";
    }
  }

  Future<void> getOriginPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      if (keywordOrigin.value == keyword) {
        originGooglePlaceTextSearchList.value = await googleMapsRepository
            .getRecommendationPlaceListByTextSearch(
              query: keywordOrigin.value,
              language: "en",
            );

        for (var location in originGooglePlaceTextSearchList) {
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
            highlightedWordAddressOrigin["${distanceMeter.round()}m ⬩"] =
                HighlightedWord(
                  onTap: () {},
                  textStyle: typographyServices.captionLargeBold.value.copyWith(
                    color: themeColorServices.neutralsColorGrey500.value,
                  ),
                );
          } else {
            highlightedWordAddressOrigin["${distanceKm.toStringAsFixed(2)}km ⬩ "] =
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

  Future<void> getDestinationPlaceLocationList({String? keyword}) async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      if (keywordDestination.value == keyword) {
        destinationGooglePlaceTextSearchList.value = await googleMapsRepository
            .getRecommendationPlaceListByTextSearch(
              query: keywordDestination.value,
              language: "en",
            );

        for (var location in destinationGooglePlaceTextSearchList) {
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
            highlightedWordAddressDestination["${distanceMeter.round()}m ⬩"] =
                HighlightedWord(
                  onTap: () {},
                  textStyle: typographyServices.captionLargeBold.value.copyWith(
                    color: themeColorServices.neutralsColorGrey500.value,
                  ),
                );
          } else {
            highlightedWordAddressDestination["${distanceKm.toStringAsFixed(2)}km ⬩ "] =
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

    focusNodeOrigin.requestFocus();

    var currentLocationDetail = await googleMapsRepository
        .getRecommendationPlaceListByLatitudeLongitude(
          language: "en",
          latitude: currentLatitude.value,
          longitude: currentLongitude.value,
        );

    recommendationOriginCurrentLocationList.value = [];
    recommendationOriginCurrentLocationList.add(
      RecommendationLocation(
        name: "Lokasi Saat Ini",
        id: "${currentLocationDetail.first.formattedAddress}",
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
        addressDetail: currentLocationDetail.first.formattedAddress,
      ),
    );
  }

  bool isLatLngOriginFilled() {
    return originLatitude.value != "" && originLongitude.value != "";
  }

  bool isLatLngDestinationFilled() {
    return destinationLatitude.value != "" && destinationLongitude.value != "";
  }

  void onTapSelectPaymentBottomSheet() async {
    Get.bottomSheet(
      Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pilih Pembayaran",
                            style: typographyServices.bodyLargeBold.value,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: 24,
                              width: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: themeColorServices.neutralsColorGrey200.value,
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  themeColorServices.sematicColorBlue100.value,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    payType.value = 2;
                                    Get.close(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: themeColorServices
                                                .neutralsColorGrey100
                                                .value,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_wallet.svg",
                                                width: 16,
                                                height: 16,
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
                                              Text(
                                                "Saldo ECGO",
                                                style: typographyServices
                                                    .bodySmallBold
                                                    .value
                                                    .copyWith(
                                                      color: themeColorServices
                                                          .neutralsColorGrey700
                                                          .value,
                                                    ),
                                              ),
                                              SizedBox(height: 2),
                                              if (homeController
                                                      .userInfo
                                                      .value
                                                      .balance! <
                                                  selectedOrderRidePricing
                                                      .value
                                                      .amount!) ...[
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/icon_alert.svg",
                                                            width: 12,
                                                            height: 12,
                                                            color: themeColorServices
                                                                .sematicColorYellow400
                                                                .value,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      NumberFormat.currency(
                                                        locale: 'id_ID',
                                                        symbol: 'Rp',
                                                        decimalDigits: 0,
                                                      ).format(
                                                        homeController
                                                                .userInfo
                                                                .value
                                                                .balance ??
                                                            0.0,
                                                      ),
                                                      style: typographyServices
                                                          .captionLargeRegular
                                                          .value
                                                          .copyWith(
                                                            color: themeColorServices
                                                                .sematicColorYellow400
                                                                .value,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                              if (homeController
                                                      .userInfo
                                                      .value
                                                      .balance! >=
                                                  selectedOrderRidePricing
                                                      .value
                                                      .amount!) ...[
                                                Text(
                                                  NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: 'Rp',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    homeController
                                                            .userInfo
                                                            .value
                                                            .balance ??
                                                        0.0,
                                                  ),
                                                  style: typographyServices
                                                      .captionLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: themeColorServices
                                                            .neutralsColorGrey500
                                                            .value,
                                                      ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        RadioGroup(
                                          groupValue: payType.value,
                                          onChanged: (value) {},
                                          child: Radio(
                                            value: 2,
                                            activeColor: themeColorServices
                                                .primaryBlue
                                                .value,
                                            backgroundColor: payType.value == 2
                                                ? WidgetStateProperty.all(
                                                    themeColorServices
                                                        .sematicColorBlue100
                                                        .value,
                                                  )
                                                : WidgetStateProperty.all(
                                                    themeColorServices
                                                        .neutralsColorGrey300
                                                        .value,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Get.toNamed(Routes.DEPOSIT_BALANCE);
                                    await homeController.getUserInfo();
                                  },
                                  child: Container(
                                    width: Get.width,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      left: 12,
                                      right: 12,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Tap disini untuk topup",
                                          style: typographyServices
                                              .captionLargeBold
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_right.svg",
                                                width: 8.67,
                                                height: 5,
                                                color: themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                            ],
                                          ),
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
                        // Padding(
                        //   padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Get.close(1);
                        //     },
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: themeColorServices
                        //             .sematicColorBlue100
                        //             .value,
                        //         borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(16),
                        //           topRight: Radius.circular(16),
                        //           bottomLeft: Radius.circular(16),
                        //           bottomRight: Radius.circular(16),
                        //         ),
                        //       ),
                        //       child: Column(
                        //         children: [
                        //           Container(
                        //             padding: EdgeInsets.symmetric(
                        //               horizontal: 12,
                        //               vertical: 16,
                        //             ),
                        //             decoration: BoxDecoration(
                        //               color: themeColorServices
                        //                   .neutralsColorGrey0
                        //                   .value,
                        //               borderRadius: BorderRadius.circular(16),
                        //               border: Border.all(
                        //                 color: themeColorServices
                        //                     .neutralsColorGrey200
                        //                     .value,
                        //               ),
                        //             ),
                        //             child: Row(
                        //               children: [
                        //                 Container(
                        //                   width: 32,
                        //                   height: 32,
                        //                   decoration: BoxDecoration(
                        //                     color: themeColorServices
                        //                         .neutralsColorGrey100
                        //                         .value,
                        //                     borderRadius: BorderRadius.circular(
                        //                       8,
                        //                     ),
                        //                   ),
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       SvgPicture.asset(
                        //                         "assets/logos/logo_dana.svg",
                        //                         width: 16,
                        //                         height: 16,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 SizedBox(width: 8),
                        //                 Expanded(
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Text(
                        //                         "Saldo DANA",
                        //                         style: typographyServices
                        //                             .bodySmallBold
                        //                             .value
                        //                             .copyWith(
                        //                               color: themeColorServices
                        //                                   .neutralsColorGrey700
                        //                                   .value,
                        //                             ),
                        //                       ),
                        //                       SizedBox(height: 2),
                        //                       Row(
                        //                         children: [
                        //                           SizedBox(
                        //                             height: 16,
                        //                             width: 16,
                        //                             child: Row(
                        //                               children: [
                        //                                 SvgPicture.asset(
                        //                                   "assets/icons/icon_alert.svg",
                        //                                   width: 12,
                        //                                   height: 12,
                        //                                   color: themeColorServices
                        //                                       .sematicColorYellow400
                        //                                       .value,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           SizedBox(width: 2),
                        //                           Text(
                        //                             "Rp5.000",
                        //                             style: typographyServices
                        //                                 .captionLargeRegular
                        //                                 .value
                        //                                 .copyWith(
                        //                                   color: themeColorServices
                        //                                       .sematicColorYellow400
                        //                                       .value,
                        //                                 ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 SizedBox(width: 8),
                        //                 Radio(
                        //                   value: "dana",
                        //                   activeColor: themeColorServices
                        //                       .primaryBlue
                        //                       .value,
                        //                   enabled: false,
                        //                   backgroundColor:
                        //                       selectedPaymentMethod.value ==
                        //                           "dana"
                        //                       ? WidgetStateProperty.all(
                        //                           themeColorServices
                        //                               .sematicColorBlue100
                        //                               .value,
                        //                         )
                        //                       : WidgetStateProperty.all(
                        //                           themeColorServices
                        //                               .neutralsColorGrey300
                        //                               .value,
                        //                         ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           Container(
                        //             padding: EdgeInsets.only(
                        //               top: 4,
                        //               left: 12,
                        //               right: 12,
                        //               bottom: 8,
                        //             ),
                        //             child: Row(
                        //               children: [
                        //                 Text(
                        //                   "Tap disini untuk topup",
                        //                   style: typographyServices
                        //                       .captionLargeBold
                        //                       .value
                        //                       .copyWith(
                        //                         color: themeColorServices
                        //                             .primaryBlue
                        //                             .value,
                        //                       ),
                        //                 ),
                        //                 SizedBox(
                        //                   width: 16,
                        //                   height: 16,
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       SvgPicture.asset(
                        //                         "assets/icons/icon_arrow_right.svg",
                        //                         width: 8.67,
                        //                         height: 5,
                        //                         color: themeColorServices
                        //                             .primaryBlue
                        //                             .value,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              payType.value = 3;
                              Get.close(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: themeColorServices
                                          .neutralsColorGrey100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_cash.svg",
                                          width: 16,
                                          height: 16,
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
                                        Text(
                                          "Cash",
                                          style: typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Siapkan uang pas untuk perjalananmu",
                                          style: typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  RadioGroup(
                                    groupValue: payType.value,
                                    onChanged: (value) {},
                                    child: Radio(
                                      value: 3,
                                      activeColor:
                                          themeColorServices.primaryBlue.value,
                                      backgroundColor: payType.value == 3
                                          ? WidgetStateProperty.all(
                                              themeColorServices
                                                  .sematicColorBlue100
                                                  .value,
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refocusMapsBound() async {
    LatLngBounds bounds;

    var originLatitude = double.parse(this.originLatitude.value);
    var originLongitude = double.parse(this.originLongitude.value);
    var destinationLatitude = double.parse(this.destinationLatitude.value);
    var destinationLongitude = double.parse(this.destinationLongitude.value);

    if (originLatitude > destinationLatitude &&
        originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, destinationLongitude),
        northeast: LatLng(originLatitude, originLongitude),
      );
    } else if (originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, destinationLongitude),
        northeast: LatLng(destinationLatitude, originLongitude),
      );
    } else if (originLatitude > destinationLatitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, originLongitude),
        northeast: LatLng(originLatitude, destinationLongitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, originLongitude),
        northeast: LatLng(destinationLatitude, destinationLongitude),
      );
    }

    final basePadding = Get.width * 0.1;
    double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
        .abs();
    double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
        .abs();
    double areaFactor = (latDiff + lngDiff) * 80000;
    var dynamicPadding = (basePadding + areaFactor).clamp(0, 250);

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
    );
  }

  Future<void> generatePolylines() async {
    var googleDirectionList = await googleMapsRepository.getDirection(
      originLatitude: originLatitude.value,
      originLongitude: originLongitude.value,
      destinationLatitude: destinationLatitude.value,
      destinationLongitude: destinationLongitude.value,
      region: "en",
    );

    var result = PolylinePoints.decodePolyline(
      googleDirectionList.first.overviewPolyline!.points!,
    );
    var polylineCoordinates = result
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
    polylinesCoordinate.value = polylineCoordinates;

    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF37C086),
        width: 6,
      ),
    );
  }

  Future<void> getOrderRidePricingList() async {
    orderRidePricingList.value = (await orderRideRepository
        .getOrderRidePricingList(
          startLonLat: "${originLongitude.value},${originLatitude.value}",
          endLonLat:
              "${destinationLongitude.value},${destinationLatitude.value}",
          language: languageServices.languageCodeSystem.value,
          type: 1,
        ));
  }

  Future<void> requestOrderRide() async {
    requestedOrderRide.value = (await orderRideRepository.requestOrderRide(
      language: languageServices.languageCodeSystem.value,
      endAddress: destinationAddress.value,
      endLat: destinationLatitude.value,
      endLon: destinationLongitude.value,
      startAddress: originAddress.value,
      startLat: originLatitude.value,
      startLon: originLongitude.value,
      orderSource: "1", // statis 1
      orderType: 1, // 1 = normal, 2 = appointment
      passengers: homeController.userInfo.value.name,
      passengersPhone: homeController.userInfo.value.phone,
      placementLat: currentLatitude.value,
      placementLon: currentLongitude.value,
      tipMoney: "0",
      serverCarModelId: selectedOrderRidePricing.value.id.toString(),
      substitute: "0", // 0 = no, 1 = yes
      travelTime: DateFormat('yyyy-MM-dd HH:mm').format(
        DateTime.now(),
      ), // kalau orderType = 1, kalau 2 maka sesuai tanggal dan jamnya
      type: "1", // 1 = Ride, 2 = Intercity
      amount: selectedOrderRidePricing.value.amount,
    ));
  }

  Future<void> onTapSelectViaMap() async {
    if (focusNodeOrigin.hasPrimaryFocus) {
      isHideMarkersAndPolylines.value = true;
      status.value = "origin_select_via_map";
    } else if (focusNodeDestination.hasPrimaryFocus) {
      isHideMarkersAndPolylines.value = true;
      status.value = "destination_select_via_map";
    } else {
      if (originTextEditingController.text == "" &&
          destinationTextEditingController.text == "") {
        isHideMarkersAndPolylines.value = true;
        status.value = "origin_select_via_map";
      } else if (originTextEditingController.text == "" &&
          destinationTextEditingController.text != "") {
        isHideMarkersAndPolylines.value = true;
        status.value = "origin_select_via_map";
      } else if (originTextEditingController.text != "" &&
          destinationTextEditingController.text == "") {
        isHideMarkersAndPolylines.value = true;
        status.value = "destination_select_via_map";
      } else if (originTextEditingController.text != "" &&
          destinationTextEditingController.text != "") {}
    }

    await onMapMoveOriginGoogleGeoCodeSearch(
      latitude: currentLatitude.value,
      longitude: currentLongitude.value,
    );
  }

  Future<void> onMapMoveOriginGoogleGeoCodeSearch({
    required String latitude,
    required String longitude,
  }) async {
    originSearchLatitude.value = latitude;
    originSearchLongitude.value = longitude;
    Future.delayed(Duration(seconds: 1), () async {
      if (originSearchLatitude.value == latitude &&
          originSearchLongitude.value == longitude) {
        if (originSearchIsLoading.value == false) {
          originSearchIsLoading.value = true;
          originGoogleGeoCodeSearch.value =
              (await googleMapsRepository
                      .getRecommendationPlaceListByLatitudeLongitude(
                        latitude: latitude,
                        longitude: longitude,
                        language: "en",
                      ))
                  .first;
          originSearchIsLoading.value = false;
        }
      }
    });
  }

  Future<void> onMapMoveDestinationGoogleGeoCodeSearch({
    required String latitude,
    required String longitude,
  }) async {
    destinationSearchLatitude.value = latitude;
    destinationSearchLongitude.value = longitude;
    Future.delayed(Duration(seconds: 1), () async {
      if (destinationSearchLatitude.value == latitude &&
          destinationSearchLongitude.value == longitude) {
        if (destinationSearchIsLoading.value == false) {
          destinationSearchIsLoading.value = true;
          destinationGoogleGeoCodeSearch.value =
              (await googleMapsRepository
                      .getRecommendationPlaceListByLatitudeLongitude(
                        latitude: latitude,
                        longitude: longitude,
                        language: "en",
                      ))
                  .first;
          destinationSearchIsLoading.value = false;
        }
      }
    });
  }

  Future<void> onTapSubmitViaMap() async {
    if (status.value == "origin_select_via_map") {
      status.value = "fill_origin_and_destination";
      originAddress.value = originGoogleGeoCodeSearch.value.formattedAddress!;
      originLatitude.value = originGoogleGeoCodeSearch
          .value
          .geometry!
          .location!
          .lat
          .toString();
      originLongitude.value = originGoogleGeoCodeSearch
          .value
          .geometry!
          .location!
          .lng
          .toString();
      originTextEditingController.text =
          originGoogleGeoCodeSearch.value.formattedAddress!;

      markers.removeWhere((m) => m.markerId.value == 'origin');
      markers.add(
        Marker(
          markerId: MarkerId("origin"),
          position: LatLng(
            double.parse(originLatitude.value),
            double.parse(originLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_origin.svg',
            Size(22.67, 22.67),
          ),
        ),
      );

      focusNodeDestination.requestFocus();
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = true;
    } else if (status.value == "destination_select_via_map") {
      status.value = "fill_origin_and_destination";
      destinationAddress.value =
          destinationGoogleGeoCodeSearch.value.formattedAddress!;
      destinationLatitude.value = destinationGoogleGeoCodeSearch
          .value
          .geometry!
          .location!
          .lat
          .toString();
      destinationLongitude.value = destinationGoogleGeoCodeSearch
          .value
          .geometry!
          .location!
          .lng
          .toString();
      destinationTextEditingController.text =
          destinationGoogleGeoCodeSearch.value.formattedAddress!;

      markers.removeWhere((m) => m.markerId.value == 'destination');
      markers.add(
        Marker(
          markerId: MarkerId("destination"),
          position: LatLng(
            double.parse(destinationLatitude.value),
            double.parse(destinationLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_pinpoint.svg',
            Size(27, 31),
          ),
        ),
      );
    }

    if (originAddress.value != "" && destinationAddress.value != "") {
      await Future.wait([
        generatePolylines(),
        refocusMapsBound(),
        getOrderRidePricingList(),
      ]);
      selectedOrderRidePricing.value = orderRidePricingList.first;
      status.value = "checkout";
      isOriginHasPrimaryFocus.value = false;
      isDestinationHasPrimaryFocus.value = false;
    }

    isHideMarkersAndPolylines.value = false;
  }

  void generateEstimatedDistanceAndTimeInMinutes() {
    estimatedDistanceInKm.value = calculateTotalDistance(polylinesCoordinate);
    estimatedTimeInMinutes.value =
        (estimatedDistanceInKm.value / estimatedSpeedInKmh.value) * 60;
  }

  String getEstimatedTimeInMinutesInText() {
    int jam = estimatedTimeInMinutes.value ~/ 60;
    int menit = (estimatedTimeInMinutes.value % 60).round();

    if (jam > 0) {
      return '$jam Jam $menit Menit';
    } else {
      return '$menit Menit';
    }
  }
}
