import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/advertisement_model.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/data/models/versioning_server_model.dart';
import 'package:new_evmoto_user/app/repositories/advertisement_repository.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/repositories/versioning_server_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/error_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';
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
  final AdvertisementRepository advertisementRepository;
  final VersioningServerRepository versioningServerRepository;

  HomeController({
    required this.userRepository,
    required this.orderRideRepository,
    required this.couponRepository,
    required this.savedAddressRepository,
    required this.geocodingRepository,
    required this.advertisementRepository,
    required this.versioningServerRepository,
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
  final locationServices = Get.find<LocationServices>();

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
  final currentLatitude = Rx<double?>(null);
  final currentLongitude = Rx<double?>(null);
  final currentAddress = Rx<String?>(null);
  final currentGeocodingAddress = GeocodingAddress().obs;
  final currentAddressIsLoading = false.obs;

  // notification
  final totalUnreadMessageCount = 0.obs;

  // advertisement
  final advertisementList = <Advertisement>[].obs;

  // app versioning
  final versioningServer = VersioningServer().obs;

  final activeOrderStatus = '-'.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;
    await refreshAll(firstInit: true);
    try {
      await socketServices.setupWebsocket();
    } on DioException catch (e) {
      print("oke-1");
      SnackbarHelper.showSnackbarError(
        text: generateErrorMessageDioException(dioException: e),
      );
      isCriticalError.value = true;
    } on Exception catch (e) {
      print("oke-2");
      SnackbarHelper.showSnackbarError(
        text: generateErrorMessageException(exception: e),
      );
      isCriticalError.value = true;
    }
    isFetch.value = false;

    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await firebasePushNotificationServices.requestPermission();
      Get.dialog(
        LoadingDialog(),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
      );
      await sendBirdServices.initialize();
      await sendbirdChatServices.initialize();
      await getTotalUnreadSendbirdChat();
      Get.close(1);
      await checkAppVersioning(isShowVersionNewestConfirmationDialog: false);

      if ((userInfo.value.name == "" || userInfo.value.name == null) &&
          userInfo.value.id != null) {
        await Get.offAllNamed(Routes.ONBOARDING_REGISTRATION_FORM);
      } else {
        await moveGoogleMapCameraToCurrentLocation();
        await Future.wait([
          getAdvertisementList(),
          getCurrentAddress(
            latitude: currentLatitude.value ?? -6.1744651,
            longitude: currentLongitude.value ?? 106.822745,
          ),
        ]);

        await checkInitialCall();
      }
    });
  }

  Future<void> checkInitialCall() async {
    if (sendBirdServices.isSuccessInitialize.value == true) {
      try {
        final calls = await FlutterCallkitIncoming.activeCalls();

        if (calls is List && calls.isNotEmpty) {
          final callData = calls.last;

          await sendBirdServices.handleFirebasePushNotificationData(
            data: callData['extra'],
          );

          await Future.delayed(Duration(milliseconds: 500));

          await Permission.microphone.request();

          await sendBirdServices.pickupCall(
            callId: jsonDecode(
              callData['extra']['sendbird_call'],
            )['command']['payload']['call_id'],
          );

          var isActive = await sendBirdServices.checkIsCallActive();

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
      } catch (e) {}
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> moveGoogleMapCameraToCurrentLocation() async {
    await locationServices.requestLocation();
    currentLatitude.value = locationServices.currentLatitude.value;
    currentLongitude.value = locationServices.currentLongitude.value;

    if (currentLatitude.value != null) {
      try {
        googleMapController.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(currentLatitude.value!, currentLongitude.value!),
          ),
        );
      } catch (e) {}
    }
  }

  Future<void> refreshAll({bool firstInit = false}) async {
    await Future.wait([
      getUserInfo(),
      getActiveOrderList(),
      getSavedAddressList(),
    ]);

    if (firstInit == false) {
      await locationServices.requestLocation();
      await Future.wait([getTotalUnreadSendbirdChat(), getAdvertisementList()]);
    }
  }

  Future<void> getUserInfo() async {
    try {
      userInfo.value = (await userRepository.getUserInfo(
        language: languageServices.languageCodeSystem.value,
      ));
    } on DioException catch (e) {
      print("oke-3");
      SnackbarHelper.showSnackbarError(
        text: generateErrorMessageDioException(dioException: e),
      );
      isCriticalError.value = true;
    } on Exception catch (e) {
      print("oke-4");
      SnackbarHelper.showSnackbarError(
        text: generateErrorMessageException(exception: e),
      );
      isCriticalError.value = true;
    }
  }

  Future<void> getActiveOrderList() async {
    try {
      activeOrderList.value = (await orderRideRepository.getActiveOrderList(
        language: languageServices.languageCodeSystem.value,
      ));

      isActiveOrderListNotEmpty.value = activeOrderList.isNotEmpty;
      await getActiveOrderStatus();
    } catch (e) {}
  }

  Future<void> getAvailableCouponList() async {
    availableCouponList.value = await couponRepository.getCouponList(
      pageNum: 1,
      size: 7,
      language: languageServices.languageCodeSystem.value,
      state: 1,
    );
  }

  Future<void> getSavedAddressList() async {
    try {
      savedAddressList.value = (await savedAddressRepository
          .getSavedAddressList());
    } catch (e) {}
  }

  Future<void> onTapRideService({
    required bool isFillCurrentLocation,
    dynamic arguments,
  }) async {
    var prefs = await SharedPreferences.getInstance();

    var isIntroductionDeliveryServiceShown =
        prefs.getBool('is_introduction_delivery_service_shown') ?? false;

    if (isIntroductionDeliveryServiceShown == false) {
      await Get.toNamed(Routes.INTRODUCTION_DELIVERY_SERVICE);
    } else {
      await refreshAll(firstInit: true);
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
            Routes.CREATE_ORDER_RIDE,
            arguments: {
              "origin_address_name": currentGeocodingAddress.value.name,
              "origin_address": currentGeocodingAddress.value.address,
              "origin_latitude": currentLatitude.value.toString(),
              "origin_longitude": currentLongitude.value.toString(),
            },
          );
        } else {
          await Get.toNamed(Routes.CREATE_ORDER_RIDE, arguments: arguments);
        }
      }
    }
    await refreshAll();
  }

  Future<void> onTapShortcutSavedLocation({
    required SavedAddress savedAddress,
  }) async {
    await refreshAll(firstInit: true);
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

  Future<void> checkAppVersioning({
    required bool isShowVersionNewestConfirmationDialog,
  }) async {
    try {
      versioningServer.value = await versioningServerRepository
          .getVersioningServer(type: 1);

      if (versioningServer.value.version != null) {
        var packageInfo = await PackageInfo.fromPlatform();
        var currentVersion = Version.parse(packageInfo.version);
        var serverVersion = Version.parse(versioningServer.value.version!);

        if (currentVersion < serverVersion) {
          await Get.dialog(
            PopScope(
              canPop: versioningServer.value.mandatory == 0,
              child: Padding(
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Image.asset(
                                  "assets/images/img_soft_update.png",
                                  width: Get.width * 169.25 / 375,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                languageServices
                                        .language
                                        .value
                                        .appUpdateAvailable ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value,
                                textAlign: TextAlign.center,
                              ),
                              if (versioningServer.value.content != null &&
                                  versioningServer.value.content != '') ...[
                                SizedBox(height: 8),
                                Text(
                                  versioningServer.value.content ?? "-",
                                  style: typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(color: Color(0XFFB3B3B3)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              SizedBox(height: 16),
                              LoaderElevatedButton(
                                onPressed: () async {
                                  await onTapUpdateVersion();
                                },
                                child: Text(
                                  languageServices.language.value.updateNow ??
                                      "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              if (versioningServer.value.mandatory == 0) ...[
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 46,
                                  width: Get.width,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Color(0XFFDBDBDB),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Get.close(1);
                                    },
                                    child: Text(
                                      languageServices
                                              .language
                                              .value
                                              .updateLater ??
                                          "-",
                                      style: typographyServices
                                          .bodyLargeBold
                                          .value
                                          .copyWith(color: Color(0XFFAFAFAF)),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          if (isShowVersionNewestConfirmationDialog == true) {
            Get.dialog(
              Padding(
                padding: const EdgeInsets.all(16),
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
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Color(0XFFDDFFE6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_checkmark_circle.svg",
                                      width: 26,
                                      height: 26,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                languageServices
                                        .language
                                        .value
                                        .usingLatestVersion ??
                                    "-",
                                style: typographyServices.bodyLargeBold.value,
                              ),
                              SizedBox(height: 16),
                              LoaderElevatedButton(
                                child: Text(
                                  languageServices.language.value.back ?? "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                              ),
                              SizedBox(height: 16),
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
        }
      }
    } catch (e) {}
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

    if (latestAppVersion > currentVersion) {
      await showDialogSoftUpdate(
        isSoftUpdateWithContent: isSoftUpdateWithContent,
      );
    }

    return latestAppVersion > currentVersion;
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
                            languageServices
                                    .language
                                    .value
                                    .appUpdateAvailable ??
                                "-",
                            style: typographyServices.bodyLargeBold.value,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            languageServices
                                    .language
                                    .value
                                    .updateAppBetterExperience ??
                                "-",
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
                              languageServices.language.value.updateNow ?? "-",
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
                                  width: 18,
                                  height: 18,
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
                    languageServices.language.value.updateApp ?? "-",
                    style: typographyServices.bodyLargeBold.value,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    languageServices.language.value.updateTheAppLatestVersion ??
                        "-",
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
                      languageServices.language.value.updateNow ?? "-",
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
      var url = Uri.parse(versioningServer.value.googlePlayLink ?? "");

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Unable launch url update app version';
      }
    } else if (Platform.isIOS) {
      var url = Uri.parse(versioningServer.value.appleStoreLink ?? "");

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
          try {
            currentGeocodingAddress.value =
                (await geocodingRepository.getAddressByLatitudeLongitude(
                  latitude: latitude,
                  longitude: longitude,
                )) ??
                GeocodingAddress();
            currentAddress.value = currentGeocodingAddress.value.address;
          } catch (e) {}
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
                            languageServices
                                    .language
                                    .value
                                    .locationAccessConsent ??
                                "-",
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
                                    width: 18,
                                    height: 18,
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
                        languageServices.language.value.needExactLocation ??
                            "-",
                        style: typographyServices.bodySmallRegular.value,
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        child: Text(
                          languageServices.language.value.enableLocation ?? "-",
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
    if (sendbirdChatServices.isSuccessInitialize.value == true) {
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

  Future<void> getAdvertisementList() async {
    advertisementList.value = [];
    try {
      if (locationServices.currentLatitude.value != null &&
          locationServices.currentLongitude.value != null) {
        advertisementList.value = await advertisementRepository
            .getAdvertisementList(
              type: 1,
              lat: locationServices.currentLatitude.value,
              lon: locationServices.currentLongitude.value,
              language: languageServices.languageCodeSystem.value,
            );

        advertisementList.sort((a, b) => a.sortNum!.compareTo(b.sortNum!));
      }
    } catch (e) {}
  }

  Future<void> getActiveOrderStatus() async {
    var activeOrderStatus = '-';

    if (activeOrderList.isNotEmpty) {
      activeOrderStatus = "Sedang Berjalan";
      // var activeOrder = activeOrderList.first;
      // var estimatedSpeedInKmh = 40.0;
      // var orderRideServer = await orderRideRepository.getOrderRideServerDetail(
      //   orderId: activeOrder.orderId!.toString(),
      //   orderType: activeOrder.orderType!,
      //   language: languageServices.languageCodeSystem.value,
      // );

      //   switch (activeOrder.state) {
      //     case 1:
      //       activeOrderStatus = 'Pencarian Driver EVMoto...';
      //       break;
      //     case 2:
      //       var estimatedTimeInMinutes = await getEstimatedTimeInMinutes(
      //         originLat: double.parse(orderRideServer.lat!),
      //         originLon: double.parse(orderRideServer.lon!),
      //         destinationLat: activeOrder.startLat!,
      //         destinationLon: activeOrder.startLon!,
      //         estimatedSpeedInKmh: estimatedSpeedInKmh,
      //       );
      //       activeOrderStatus =
      //           'Driver segera tiba, menunggu: ${getEstimatedTimeInMinutesInText(estimatedTimeInMinutes: estimatedTimeInMinutes)}';
      //       break;
      //     case 3:
      //       activeOrderStatus = 'Driver tiba di titik penjemputan';
      //       break;
      //     case 4:
      //       activeOrderStatus = 'Berangkat menuju lokasi';
      //       break;
      //     case 5:
      //       var estimatedTimeInMinutes = await getEstimatedTimeInMinutes(
      //         originLat: double.parse(orderRideServer.lat!),
      //         originLon: double.parse(orderRideServer.lon!),
      //         destinationLat: activeOrder.endLat!,
      //         destinationLon: activeOrder.endLon!,
      //         estimatedSpeedInKmh: estimatedSpeedInKmh,
      //       );
      //       var estimatedDistanceInKm = await getEstimatedDistanceInKm(
      //         originLat: double.parse(orderRideServer.lat!),
      //         originLon: double.parse(orderRideServer.lon!),
      //         destinationLat: activeOrder.endLat!,
      //         destinationLon: activeOrder.endLon!,
      //       );
      //       activeOrderStatus =
      //           '${formatDoubleToString(estimatedDistanceInKm)} ${languageServices.language.value.km} ·󠁏󠁏 ${getEstimatedTimeInMinutesInText(estimatedTimeInMinutes: estimatedTimeInMinutes)} sampai ke lokasi';
      //       break;
      //     case 6:
      //       var estimatedDistanceInKm = await getEstimatedDistanceInKm(
      //         originLat: double.parse(orderRideServer.lat!),
      //         originLon: double.parse(orderRideServer.lon!),
      //         destinationLat: activeOrder.endLat!,
      //         destinationLon: activeOrder.endLon!,
      //       );
      //       activeOrderStatus =
      //           '${formatDoubleToString(estimatedDistanceInKm)} ${languageServices.language.value.km} ·󠁏󠁏 Sampai di lokasi';
      //       break;
      //     case 7:
      //       activeOrderStatus = 'Konfirmasi pembayaran';
      //       break;
      //     default:
      //       activeOrderStatus = '-';
      //       break;
      //   }
    }

    this.activeOrderStatus.value = activeOrderStatus;
  }
}
