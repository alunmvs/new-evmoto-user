import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeController extends GetxController {
  final UserRepository userRepository;
  final OrderRideRepository orderRideRepository;
  final CouponRepository couponRepository;
  final SavedAddressRepository savedAddressRepository;

  HomeController({
    required this.userRepository,
    required this.orderRideRepository,
    required this.couponRepository,
    required this.savedAddressRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final socketServices = Get.find<SocketServices>();

  final bannerUrlList = [
    "assets/images/img_promo_1.png",
    "assets/images/img_promo_2.png",
  ];
  final indexBanner = 0.0.obs;
  final indexNavigationBar = 0.obs;

  final userInfo = UserInfo().obs;
  final activeOrderList = <ActiveOrder>[].obs;
  final availableCouponList = <Coupon>[].obs;

  final savedAddressList = <SavedAddress>[].obs;

  // coachmark
  final destinationGlobalKey = GlobalKey();
  final savedLocationGlobalKey = GlobalKey();
  final servicesGlobalKey = GlobalKey();
  final balanceGlobalKey = GlobalKey();

  final isCoachmarkActive = false.obs;
  final lastPressedBackDateTime = DateTime.now().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await refreshAll();
    await socketServices.setupWebsocket();
    isFetch.value = false;

    ShowcaseView.register();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await displayCoachmark();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      getUserInfo(),
      getActiveOrderList(),
      getAvailableCouponList(),
      getSavedAddressList(),
    ]);
  }

  Future<void> getUserInfo() async {
    userInfo.value = (await userRepository.getUserInfo(
      language: languageServices.languageCodeSystem.value,
    ));
  }

  Future<void> getActiveOrderList() async {
    activeOrderList.value = (await orderRideRepository.getActiveOrderList(
      language: languageServices.languageCodeSystem.value,
    ));
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

  Future<void> onTapRideService() async {
    var prefs = await SharedPreferences.getInstance();

    var isIntroductionDeliveryServiceShown =
        prefs.getBool('is_introduction_delivery_service_shown') ?? false;

    if (isIntroductionDeliveryServiceShown == false) {
      await Get.toNamed(Routes.INTRODUCTION_DELIVERY_SERVICE);
    } else {
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
        await Get.toNamed(Routes.RIDE);
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
        Padding(
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
                            SizedBox(
                              width: Get.width,
                              height: 46,
                              child: ElevatedButton(
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      themeColorServices.primaryBlue.value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
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
      );
    }
  }
}
