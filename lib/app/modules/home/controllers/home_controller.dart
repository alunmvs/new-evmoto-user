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
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/order_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/utils/time_process_helper.dart';
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
  final userServices = Get.find<UserServices>();

  final bannerUrlList = [
    "assets/images/img_promo_1.png",
    "assets/images/img_promo_2.png",
  ];
  final indexBanner = 0.0.obs;
  final indexNavigationBar = 0.obs;

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
  final currentLatitude = Rx<double?>(-6.1744651);
  final currentLongitude = Rx<double?>(106.822745);
  final currentAddress = Rx<String?>(null);
  final currentGeocodingAddress = GeocodingAddress().obs;
  final currentAddressIsLoading = false.obs;
  final isCurrentAddressIsInit = false.obs;

  // notification
  final totalUnreadMessageCount = 0.obs;
  final isFetchTotalUnreadMessageCount = false.obs;

  // sendbird SDK
  final isSendbirdInit = false.obs;

  // advertisement
  final advertisementList = <Advertisement>[].obs;
  final isFetchAdvertisementList = true.obs;

  // app versioning
  final versioningServer = VersioningServer().obs;

  final activeOrderStatus = '-'.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    ShowcaseView.register();

    isFetch.value = true;
    isCriticalError.value = false;
    if (locationServices.currentLatitude.value == null) {
      await locationServices.requestLocation();
    }
    await measureTime(
      "Refresh All",
      () => Future.wait([
        refreshAll(firstInit: true),
        getAdvertisementList(),
        getCurrentAddressInitialize(
          latitude: currentLatitude.value ?? -6.1744651,
          longitude: currentLongitude.value ?? 106.822745,
        ),
      ]),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await measureTime(
      //   "Move Google Map Camera to Current Location",
      //   () => Future.wait([moveGoogleMapCameraToCurrentLocation()]),
      // );

      await firebasePushNotificationServices.requestPermission();
      await measureTime(
        "Sendbird Chat & Call Initialize",
        () => Future.wait([
          sendBirdServices.initialize(),
          sendbirdChatServices.initialize(),
        ]),
      );
      await getTotalUnreadSendbirdChat();
      isSendbirdInit.value = true;
      await checkAppVersioning(isShowVersionNewestConfirmationDialog: false);

      if ((userServices.userInfo.value.name == "" ||
              userServices.userInfo.value.name == null) &&
          userServices.userInfo.value.id != null) {
        await Get.offAllNamed(Routes.ONBOARDING_REGISTRATION_FORM);
      } else {
        await checkInitialCall();
      }
      await setHomeControllerRegistered();
      isFetch.value = false;
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

  Future<void> setHomeControllerRegistered() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('home_controller_registered', true);
  }

  Future<void> moveGoogleMapCameraToCurrentLocation() async {
    if (locationServices.currentLatitude.value != null) {
      currentLatitude.value = locationServices.currentLatitude.value;
      currentLongitude.value = locationServices.currentLongitude.value;

      if (currentLatitude.value != null) {
        try {
          googleMapController.moveCamera(
            CameraUpdate.newLatLng(
              LatLng(currentLatitude.value!, currentLongitude.value!),
            ),
          );

          initialCameraPosition.value = CameraPosition(
            target: LatLng(currentLatitude.value!, currentLongitude.value!),
            zoom: 14,
          );
        } catch (e) {}
      }
    } else {}
  }

  Future<void> refreshAll({bool firstInit = false}) async {
    try {
      await Future.wait([
        getActiveOrderList(),
        getSavedAddressList(),
      ], eagerError: false);

      if (firstInit == false) {
        await locationServices.requestLocationSplashScreen();
        await Future.wait([
          userServices.getUserInfo(),
          getTotalUnreadSendbirdChat(),
          getAdvertisementList(),
        ], eagerError: false);
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    }
  }

  Future<void> getActiveOrderList() async {
    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));

    isActiveOrderListNotEmpty.value = activeOrderList.isNotEmpty;
    await getActiveOrderStatus();
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
    savedAddressList.value = (await savedAddressRepository
        .getSavedAddressList());
  }

  Future<void> onTapPickUpLocation() async {
    await refreshAll(firstInit: true);
    if (isActiveOrderListNotEmpty.value) {
      try {
        var isCancelled = await isOrderHasBeenCancelled(
          orderId: activeOrderList.first.orderId.toString(),
          orderType: activeOrderList.first.orderType!,
        );

        if (isCancelled == true) {
          SnackbarHelper.showSnackbarError(
            text: languageServices.language.value.orderHasBeenCancelled ?? "-",
          );
          await refreshAll(firstInit: false);
          return;
        }
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
      }

      await Get.toNamed(
        Routes.RIDE_ORDER_DETAIL,
        arguments: {
          "order_id": activeOrderList.first.orderId.toString(),
          "order_type": activeOrderList.first.orderType,
        },
      );
    } else {
      try {
        // var result = await Get.toNamed(
        //   Routes.CREATE_ORDER_RIDE_MAP_SELECT,
        //   arguments: {
        //     "type": "origin",
        //     "address": geocodingAddress!.name,
        //     "address_name": geocodingAddress.address,
        //     "latitude": currentLatitude.value.toString(),
        //     "longitude": currentLongitude.value.toString(),
        //   },
        // );

        // if (result != null) {

        await Future.doWhile(() async {
          await Future.delayed(Duration(milliseconds: 100));
          return currentAddressIsLoading.value;
        });

        await Get.toNamed(
          Routes.CREATE_ORDER_RIDE,
          arguments: {
            "origin_address_name": currentGeocodingAddress.value.name,
            "origin_address": currentGeocodingAddress.value.address,
            "origin_latitude": currentLatitude.value.toString(),
            "origin_longitude": currentLongitude.value.toString(),
          },
        );
        // }
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
        Get.close(1);
      }
    }
  }

  Future<void> onTapWhereAreYouGoingToday() async {
    await refreshAll(firstInit: true);
    if (isActiveOrderListNotEmpty.value) {
      try {
        var isCancelled = await isOrderHasBeenCancelled(
          orderId: activeOrderList.first.orderId.toString(),
          orderType: activeOrderList.first.orderType!,
        );

        if (isCancelled == true) {
          SnackbarHelper.showSnackbarError(
            text: languageServices.language.value.orderHasBeenCancelled ?? "-",
          );
          await refreshAll(firstInit: false);
          return;
        }
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
      }

      await Get.toNamed(
        Routes.RIDE_ORDER_DETAIL,
        arguments: {
          "order_id": activeOrderList.first.orderId.toString(),
          "order_type": activeOrderList.first.orderType,
        },
      );
    } else {
      try {
        await Future.doWhile(() async {
          await Future.delayed(Duration(milliseconds: 100));
          return currentAddressIsLoading.value;
        });

        await Get.toNamed(
          Routes.CREATE_ORDER_RIDE,
          arguments: {
            "is_origin_auto_select": true,
            "origin_address_name": currentGeocodingAddress.value.name,
            "origin_address": currentGeocodingAddress.value.address,
            "origin_latitude": currentLatitude.value.toString(),
            "origin_longitude": currentLongitude.value.toString(),
          },
        );
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
        Get.close(1);
      }
    }
  }

  Future<void> onTapRideService({
    required bool isFillCurrentLocation,
    dynamic arguments,
  }) async {
    await refreshAll(firstInit: true);
    if (isActiveOrderListNotEmpty.value) {
      try {
        var isCancelled = await isOrderHasBeenCancelled(
          orderId: activeOrderList.first.orderId.toString(),
          orderType: activeOrderList.first.orderType!,
        );

        if (isCancelled == true) {
          SnackbarHelper.showSnackbarError(
            text: languageServices.language.value.orderHasBeenCancelled ?? "-",
          );
          await refreshAll(firstInit: false);
          return;
        }
      } on DioException catch (e) {
        SnackbarHelper.showSnackbarError(text: e.error.toString());
      }
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

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
          var prefs = await SharedPreferences.getInstance();
          var lastUpdateLaterClickAt = prefs.getString(
            "last_update_later_click_at",
          );

          var isShow = false;

          if (isShowVersionNewestConfirmationDialog == true) {
            isShow = true;
          } else {
            if (lastUpdateLaterClickAt != null) {
              var lastUpdateLaterClickAtDateTime =
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(lastUpdateLaterClickAt),
                  );

              if (isSameDay(lastUpdateLaterClickAtDateTime, DateTime.now())) {
                isShow = false;
              } else {
                isShow = true;
              }
            } else {
              isShow = true;
            }
          }

          if (isShow == true) {
            await Get.dialog(
              PopScope(
                canPop: false,
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
                                    style: typographyServices
                                        .bodyLargeBold
                                        .value
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
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Get.close(1);

                                        var prefs =
                                            await SharedPreferences.getInstance();
                                        await prefs.setString(
                                          "last_update_later_click_at",
                                          DateTime.now().millisecondsSinceEpoch
                                              .toString(),
                                        );
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
          }
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
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
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
    currentAddressIsLoading.value = true;
    currentLatitude.value = latitude;
    currentLongitude.value = longitude;
    Future.delayed(Duration(seconds: 1), () async {
      if (currentLatitude.value == latitude &&
          currentLongitude.value == longitude) {
        try {
          currentGeocodingAddress.value =
              (await geocodingRepository.getAddressByLatitudeLongitude(
                latitude: latitude,
                longitude: longitude,
              )) ??
              GeocodingAddress();
          currentAddress.value = currentGeocodingAddress.value.address;
        } on DioException catch (e) {
          SnackbarHelper.showSnackbarError(text: e.error.toString());
        }
        currentAddressIsLoading.value = false;
      }
    });
  }

  Future<void> getCurrentAddressInitialize({
    required double latitude,
    required double longitude,
  }) async {
    try {
      if (locationServices.currentLatitude.value != null) {
        currentGeocodingAddress.value = locationServices.geocodingAddress.value;
        currentAddress.value = currentGeocodingAddress.value.address;
      } else {
        currentGeocodingAddress.value =
            (await geocodingRepository.getAddressByLatitudeLongitude(
              latitude: latitude,
              longitude: longitude,
            )) ??
            GeocodingAddress();
        currentAddress.value = currentGeocodingAddress.value.address;
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    }
    isCurrentAddressIsInit.value = true;
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
      if (isFetchTotalUnreadMessageCount.value == false) {
        isFetchTotalUnreadMessageCount.value = true;
        var query = GroupChannelListQuery();
        var channelList = await query.next();

        for (var channel in channelList) {
          for (var member in channel.members) {
            if (member.userId == "user_${userServices.userInfo.value.id}") {
              totalUnreadMessageCount.value += channel.unreadMessageCount;
            }
          }
        }
        isFetchTotalUnreadMessageCount.value = false;
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
      } else {
        advertisementList.value = [];
      }
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    }
    isFetchAdvertisementList.value = false;
  }

  Future<void> getActiveOrderStatus() async {
    var activeOrderStatus = '-';

    if (activeOrderList.isNotEmpty) {
      activeOrderStatus = languageServices.language.value.inProcess ?? "-";
      // var activeOrder = activeOrderList.first;
      // var estimatedSpeedInKmh = 40.0;
      // var orderRideServer = await orderRideRepository.getOrderRideServerDetail(
      //   orderId: activeOrder.orderId!.toString(),
      //   orderType: activeOrder.orderType!,
      //   language: languageServices.languageCodeSystem.value,
      // );

      // switch (activeOrder.state) {
      //   case 1:
      //     activeOrderStatus = 'Pencarian Driver EVMoto...';
      //     break;
      //   case 2:
      //     var estimatedTimeInMinutes = await getEstimatedTimeInMinutes(
      //       originLat: double.parse(orderRideServer.lat!),
      //       originLon: double.parse(orderRideServer.lon!),
      //       destinationLat: activeOrder.startLat!,
      //       destinationLon: activeOrder.startLon!,
      //       estimatedSpeedInKmh: estimatedSpeedInKmh,
      //     );
      //     activeOrderStatus =
      //         'Driver segera tiba, menunggu: ${getEstimatedTimeInMinutesInText(estimatedTimeInMinutes: estimatedTimeInMinutes)}';
      //     break;
      //   case 3:
      //     activeOrderStatus = 'Driver tiba di titik penjemputan';
      //     break;
      //   case 4:
      //     activeOrderStatus = 'Berangkat menuju lokasi';
      //     break;
      //   case 5:
      //     var estimatedTimeInMinutes = await getEstimatedTimeInMinutes(
      //       originLat: double.parse(orderRideServer.lat!),
      //       originLon: double.parse(orderRideServer.lon!),
      //       destinationLat: activeOrder.endLat!,
      //       destinationLon: activeOrder.endLon!,
      //       estimatedSpeedInKmh: estimatedSpeedInKmh,
      //     );
      //     var estimatedDistanceInKm = await getEstimatedDistanceInKm(
      //       originLat: double.parse(orderRideServer.lat!),
      //       originLon: double.parse(orderRideServer.lon!),
      //       destinationLat: activeOrder.endLat!,
      //       destinationLon: activeOrder.endLon!,
      //     );
      //     activeOrderStatus =
      //         '${formatDoubleToString(estimatedDistanceInKm)} ${languageServices.language.value.km} ·󠁏󠁏 ${getEstimatedTimeInMinutesInText(estimatedTimeInMinutes: estimatedTimeInMinutes)} sampai ke lokasi';
      //     break;
      //   case 6:
      //     var estimatedDistanceInKm = await getEstimatedDistanceInKm(
      //       originLat: double.parse(orderRideServer.lat!),
      //       originLon: double.parse(orderRideServer.lon!),
      //       destinationLat: activeOrder.endLat!,
      //       destinationLon: activeOrder.endLon!,
      //     );
      //     activeOrderStatus =
      //         '${formatDoubleToString(estimatedDistanceInKm)} ${languageServices.language.value.km} ·󠁏󠁏 Sampai di lokasi';
      //     break;
      //   case 7:
      //     activeOrderStatus = 'Konfirmasi pembayaran';
      //     break;
      //   default:
      //     activeOrderStatus = '-';
      //     break;
      // }
    }

    this.activeOrderStatus.value = activeOrderStatus;
  }
}
