import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/active_order_model.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final UserRepository userRepository;
  final OrderRideRepository orderRideRepository;
  final CouponRepository couponRepository;

  HomeController({
    required this.userRepository,
    required this.orderRideRepository,
    required this.couponRepository,
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

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await refreshAll();
    await socketServices.setupWebsocket();
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

  Future<void> refreshAll() async {
    await Future.wait([
      getUserInfo(),
      getActiveOrderList(),
      getAvailableCouponList(),
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
}
