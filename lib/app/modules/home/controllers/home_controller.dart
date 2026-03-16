import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final UserRepository userRepository;
  final OrderRideRepository orderRideRepository;
  final CouponRepository couponRepository;
  final SavedAddressRepository savedAddressRepository;
  final GeocodingRepository geocodingRepository;

  HomeController({
    required this.userRepository,
    required this.orderRideRepository,
    required this.couponRepository,
    required this.savedAddressRepository,
    required this.geocodingRepository,
  });

  final homeRefreshController = RefreshController();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final socketServices = Get.find<SocketServices>();
  final firebasePushNotificationServices =
      Get.find<FirebasePushNotificationServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final sendBirdServices = Get.find<SendbirdServices>();
  final sendbirdChatServices = Get.find<SendbirdChatServices>();

  final bannerUrlList = [
    "assets/images/img_promo_1.png",
    "assets/images/img_promo_2.png",
  ];
  final indexBanner = 0.0.obs;
  final indexNavigationBar = 0.obs;

  final userInfo = UserInfo().obs;
  final activeOrderList = <ActiveOrder>[].obs;
  final availableCouponList = <Coupon>[].obs;

  final isActiveOrderListNotEmpty = false.obs;

  final savedAddressList = <SavedAddress>[].obs;

  // coachmark
  final destinationGlobalKey = GlobalKey();
  final savedLocationGlobalKey = GlobalKey();
  final servicesGlobalKey = GlobalKey();
  final balanceGlobalKey = GlobalKey();

  final isCoachmarkActive = false.obs;
  final lastPressedBackDateTime = DateTime.now().obs;

  // google maps
  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  // location permission
  final isPermissionLocationAllow = true.obs;
  final userCurrentLatitude = Rx<double?>(null);
  final userCurrentLongitude = Rx<double?>(null);
  final currentLatitude = Rx<double?>(null);
  final currentLongitude = Rx<double?>(null);
  final currentAddress = Rx<String?>(null);
  final currentAddressIsLoading = false.obs;

  // notification
  final totalUnreadMessageCount = 0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await refreshAll(firstInit: true);
    await socketServices.setupWebsocket();
    await Future.wait([sendBirdServices.initialize()]);
    isFetch.value = false;

    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkForceUpdate();
      await checkSoftUpdate();
      await moveGoogleMapCameraToCurrentLocation();

      if (userInfo.value.name == "" || userInfo.value.name == null) {
        await Get.offAllNamed(Routes.ONBOARDING_REGISTRATION_FORM);
      } else {
        // await displayCoachmark();
        await requestLocation();
        await getCurrentAddress(
          latitude: currentLatitude.value ?? -6.1744651,
          longitude: currentLongitude.value ?? 106.822745,
        );
        await firebasePushNotificationServices.requestPermission();

        await checkInitialCall();

        if (isPermissionLocationAllow.value == false) {
          await showRequiredAccessPermission();
        }

        await sendbirdChatServices.initialize();
        await getTotalUnreadSendbirdChat();
      }
    });
  }

  Future<void> checkInitialCall() async {
    // Ambil daftar panggilan aktif
    final calls = await FlutterCallkitIncoming.activeCalls();

    if (calls is List && calls.isNotEmpty) {
      // Ambil data panggilan terakhir (biasanya yang baru saja diterima)
      final callData = calls.last;

      final sendbirdServices = Get.find<SendbirdServices>();
      await sendbirdServices.handleFirebasePushNotificationData(
        data: callData['extra'],
      );

      await Future.delayed(Duration(milliseconds: 500));

      await Permission.microphone.request();

      await sendbirdServices.pickupCall(
        callId: jsonDecode(
          callData['extra']['sendbird_call'],
        )['command']['payload']['call_id'],
      );

      var isActive = await sendbirdServices.checkIsCallActive();

      if (isActive == true) {
        Get.toNamed(
          Routes.RIDE_CALL_SENDBIRD,
          arguments: {
            "call_id": jsonDecode(
              callData['extra']['sendbird_call'],
            )['command']['payload']['call_id'],
            "is_caller": false,
            "driver_id": null,
            "driver_name": jsonDecode(
              callData['extra']['sendbird_call'],
            )['command']['payload']['caller']['nickname'],
            "driver_avatar_url":
                jsonDecode(
                      callData['extra']['sendbird_call'],
                    )['command']['payload']['caller']['profile_url'] ==
                    ''
                ? null
                : jsonDecode(
                    callData['extra']['sendbird_call'],
                  )['command']['payload']['caller']['profile_url'],
          },
        );
      } else {
        FlutterCallkitIncoming.endAllCalls();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    FlutterCallkitIncoming.endAllCalls();
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

    currentLatitude.value = position.latitude;
    currentLongitude.value = position.longitude;
    userCurrentLatitude.value = position.latitude;
    userCurrentLongitude.value = position.longitude;
  }

  Future<void> moveGoogleMapCameraToCurrentLocation() async {
    await requestLocation();

    if (currentLatitude.value != null) {
      googleMapController.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLatitude.value!, currentLongitude.value!),
        ),
      );
    }
  }

  Future<void> refreshAll({bool firstInit = false}) async {
    await Future.wait([
      getUserInfo(),
      getActiveOrderList(),
      getAvailableCouponList(),
      getSavedAddressList(),
    ]);

    if (firstInit == false) {
      await getTotalUnreadSendbirdChat();
    }
  }

  Future<void> getUserInfo() async {
    try {
      userInfo.value = (await userRepository.getUserInfo(
        language: languageServices.languageCodeSystem.value,
      ));
    } catch (e) {}
  }

  Future<void> getActiveOrderList() async {
    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));

    isActiveOrderListNotEmpty.value = activeOrderList.isNotEmpty;
  }

  Future<void> getAvailableCouponList() async {
    try {
      availableCouponList.value = await couponRepository.getCouponList(
        pageNum: 1,
        size: 7,
        language: languageServices.languageCodeSystem.value,
        state: 1,
      );
    } catch (e) {}
  }

  Future<void> getSavedAddressList() async {
    try {
      savedAddressList.value = (await savedAddressRepository
          .getSavedAddressList());
    } catch (e) {}
  }

  Future<void> onTapRideService({required bool isFillCurrentLocation}) async {
    var prefs = await SharedPreferences.getInstance();

    var isIntroductionDeliveryServiceShown =
        prefs.getBool('is_introduction_delivery_service_shown') ?? false;

    if (isIntroductionDeliveryServiceShown == false) {
      await Get.toNamed(Routes.INTRODUCTION_DELIVERY_SERVICE);
    } else {
      await refreshAll();
      if (isActiveOrderListNotEmpty.value) {
        await Get.toNamed(
          Routes.RIDE_ORDER_DETAIL,
          arguments: {
            "order_id": activeOrderList.first.orderId.toString(),
            "order_type": activeOrderList.first.orderType,
          },
        );
      } else {
        if (isFillCurrentLocation == true) {
          await Get.toNamed(
            Routes.RIDE,
            arguments: {
              "start_address": currentAddress.value,
              "start_lat": currentLatitude.value,
              "start_lon": currentLongitude.value,
            },
          );
        } else {
          await Get.toNamed(Routes.RIDE);
        }
      }
    }
    await refreshAll();
  }

  Future<void> onTapShortcutSavedLocation({
    required SavedAddress savedAddress,
  }) async {
    await refreshAll();
    if (activeOrderList.isNotEmpty) {
      await Get.toNamed(
        Routes.RIDE_ORDER_DETAIL,
        arguments: {
          "order_id": activeOrderList.first.orderId.toString(),
          "order_type": activeOrderList.first.orderType,
        },
      );
    } else {
      await Get.toNamed(
        Routes.RIDE,
        arguments: {"destination_saved_address": savedAddress},
      );
    }

    await refreshAll();
  }

  Future<void> displayCoachmark() async {
    var prefs = await SharedPreferences.getInstance();
    var isCoachmarkDisplayed = prefs.getBool('is_coachmark_displayed') ?? false;

    if (isCoachmarkDisplayed == false) {
      await Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: themeColorServices.neutralsColorGrey0.value,
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 325 / 110,
                          child: Image.asset(
                            "assets/images/img_coachmark.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                languageServices
                                        .language
                                        .value
                                        .dialogCoachmarkTitle ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 8),
                              Text(
                                languageServices
                                        .language
                                        .value
                                        .dialogCoachmarkDescription ??
                                    "-",
                                style: typographyServices.bodySmallRegular.value
                                    .copyWith(),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              LoaderElevatedButton(
                                onPressed: () async {
                                  Get.close(1);

                                  isCoachmarkActive.value = true;

                                  ShowcaseView.get().startShowCase([
                                    destinationGlobalKey,
                                    savedLocationGlobalKey,
                                    servicesGlobalKey,
                                    balanceGlobalKey,
                                  ]);
                                },
                                child: Text(
                                  languageServices
                                          .language
                                          .value
                                          .dialogCoachmarkButton ??
                                      "-",
                                  style: typographyServices.bodySmallBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
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
      );
    }
  }

  Future<bool> checkSoftUpdate() async {
    var userAppVersion = jsonDecode(
      firebaseRemoteConfigServices.remoteConfig.getString("user_app_version"),
    );
    var isSoftUpdateWithContent = firebaseRemoteConfigServices.remoteConfig
        .getBool("soft_update_with_content");

    var packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = Version.parse(packageInfo.version);
    var latestAppVersion = Version.parse(userAppVersion['latest_app_version']);

    if (latestAppVersion < currentVersion) {
      await showDialogSoftUpdate(
        isSoftUpdateWithContent: isSoftUpdateWithContent,
      );
    }

    return latestAppVersion < currentVersion;
  }

  Future<bool> checkForceUpdate() async {
    var userAppVersion = jsonDecode(
      firebaseRemoteConfigServices.remoteConfig.getString("user_app_version"),
    );

    var packageInfo = await PackageInfo.fromPlatform();
    var currentVersion = Version.parse(packageInfo.version);
    var minAppVersion = Version.parse(userAppVersion['min_app_version']);

    if (minAppVersion > currentVersion) {
      await showDialogForceUpdate();
    }

    return minAppVersion > currentVersion;
  }

  Future<void> showDialogSoftUpdate({
    required bool isSoftUpdateWithContent,
  }) async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 16 + 16),
                          if (isSoftUpdateWithContent == true) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Image.asset(
                                "assets/images/img_soft_update.png",
                                width: Get.width * 197 / 375,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                          Text(
                            "Pembaruan Aplikasi Tersedia",
                            style: typographyServices.bodyLargeBold.value,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Perbarui aplikasi untuk pengalaman yang lebih baik.",
                            style: typographyServices.bodySmallRegular.value
                                .copyWith(color: Color(0XFFB3B3B3)),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          LoaderElevatedButton(
                            onPressed: () async {
                              await onTapUpdateVersion();
                            },
                            child: Text(
                              "Update Sekarang",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                      Positioned(
                        top: 16,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: 24,
                            height: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 12,
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDialogForceUpdate() async {
    await Get.dialog(
      PopScope(
        canPop: false,
        child: Material(
          color: themeColorServices.neutralsColorGrey0.value,
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.asset(
                        "assets/images/img_force_update.png",
                        width: Get.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Perbarui Aplikasi Anda",
                    style: typographyServices.bodyLargeBold.value,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Untuk melanjutkan penggunaan, silakan perbarui aplikasi ke versi terbaru.",
                    style: typographyServices.bodySmallRegular.value.copyWith(
                      color: Color(0XFFB3B3B3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  LoaderElevatedButton(
                    onPressed: () async {
                      await onTapUpdateVersion();
                    },
                    child: Text(
                      "Update Sekarang",
                      style: typographyServices.bodyLargeBold.value.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> onTapUpdateVersion() async {
    if (Platform.isAndroid) {
      var url = Uri.parse(
        firebaseRemoteConfigServices.remoteConfig.getString(
          "user_playstore_link",
        ),
      );

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Unable launch url update app version';
      }
    } else if (Platform.isIOS) {
      var url = Uri.parse(
        firebaseRemoteConfigServices.remoteConfig.getString(
          "user_appstore_link",
        ),
      );

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Unable launch url update app version';
      }
    }
  }

  Future<void> getCurrentAddress({
    required double latitude,
    required double longitude,
  }) async {
    currentLatitude.value = latitude;
    currentLongitude.value = longitude;
    Future.delayed(Duration(seconds: 1), () async {
      if (currentLatitude.value == latitude &&
          currentLongitude.value == longitude) {
        if (currentAddressIsLoading.value == false) {
          currentAddressIsLoading.value = true;
          currentAddress.value = await geocodingRepository
              .getAddressByLatitudeLongitude(
                latitude: latitude,
                longitude: longitude,
              );
          currentAddressIsLoading.value = false;
        }
      }
    });
  }

  Future<void> checkAndEnableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> showRequiredAccessPermission() async {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Persetujuan Akses Lokasi",
                            style: typographyServices.bodyLargeBold.value
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 304.5 / 125,
                          child: Image.asset(
                            'assets/images/img_location_required.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Kami membutuhkan lokasi Anda yang tepat agar dapat melayani Anda dengan lebih baik.",
                        style: typographyServices.bodySmallRegular.value,
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        child: Text(
                          "Aktifkan Lokasi",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
                        onPressed: () async {
                          await checkAndEnableLocation();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getTotalUnreadSendbirdChat() async {
    totalUnreadMessageCount.value = 0;
    var query = GroupChannelListQuery();
    var channelList = await query.next();

    for (var channel in channelList) {
      for (var member in channel.members) {
        if (member.userId == "user_${userInfo.value.id}") {
          totalUnreadMessageCount.value += channel.unreadMessageCount;
        }
      }
    }
  }

  bool isBookmarkHomeIsSet() {
    var result = false;
    for (var savedAddressList in savedAddressList) {
      if (savedAddressList.addressType == 1) {
        result = true;
      }
    }
    return result;
  }

  bool isBookmarkCompanyIsSet() {
    var result = false;
    for (var savedAddressList in savedAddressList) {
      if (savedAddressList.addressType == 2) {
        result = true;
      }
    }
    return result;
  }
}
