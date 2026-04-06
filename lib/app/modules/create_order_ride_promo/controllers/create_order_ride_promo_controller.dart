import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CreateOrderRidePromoController extends GetxController {
  final CouponRepository couponRepository;

  CreateOrderRidePromoController({required this.couponRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final selectedCouponId = Rx<int?>(null);
  final selectedCoupon = Coupon().obs;
  final couponList = <Coupon>[].obs;

  final refreshController = RefreshController();
  final pageNum = 1.obs;
  final size = 10.obs;
  final isSeeMoreCouponList = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    selectedCoupon.value = Get.arguments['selected_coupon'] ?? Coupon();
    selectedCouponId.value = selectedCoupon.value.id;
    await getCouponList();
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

  Future<void> getCouponList() async {
    pageNum.value = 1;

    couponList.value = await couponRepository.getCouponList(
      language: languageServices.languageCodeSystem.value,
      pageNum: pageNum.value,
      size: size.value,
      state: 1,
    );

    isSeeMoreCouponList.value = couponList.isNotEmpty;
  }

  Future<void> seeMoreCouponList() async {
    pageNum.value += 1;

    if (isSeeMoreCouponList.value == true) {
      var couponList = await couponRepository.getCouponList(
        language: languageServices.languageCodeSystem.value,
        pageNum: pageNum.value,
        size: size.value,
        state: 1,
      );

      this.couponList.addAll(couponList);
      isSeeMoreCouponList.value = couponList.isNotEmpty;
    }
  }
}
