import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PromotionController extends GetxController {
  final CouponRepository couponRepository;

  PromotionController({required this.couponRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final availableCouponList = <Coupon>[].obs;
  final availableCouponPageNum = 1.obs;
  final isSeeMoreAvailableCoupon = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getAvailableCouponList();
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

  Future<void> getAvailableCouponList() async {
    availableCouponPageNum.value = 1;
    isSeeMoreAvailableCoupon.value = true;

    availableCouponList.value = await couponRepository.getCouponList(
      pageNum: availableCouponPageNum.value,
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 1,
    );

    if (availableCouponList.isEmpty) {
      isSeeMoreAvailableCoupon.value = false;
    }
  }

  Future<void> seeMoreAvailableCouponList() async {
    availableCouponPageNum.value += 1;

    var availableCouponList = await couponRepository.getCouponList(
      pageNum: availableCouponPageNum.value,
      size: 10,
      language: languageServices.languageCodeSystem.value,
      state: 1,
    );

    if (availableCouponList.isEmpty) {
      isSeeMoreAvailableCoupon.value = false;
    }

    this.availableCouponList.addAll(availableCouponList);
  }
}
