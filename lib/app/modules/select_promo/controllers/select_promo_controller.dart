import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class SelectPromoController extends GetxController {
  final CouponRepository couponRepository;

  SelectPromoController({required this.couponRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final availableCouponList = <Coupon>[].obs;
  final availableCouponPageNum = 1.obs;
  final isSeeMoreAvailableCouponList = true.obs;

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
    isSeeMoreAvailableCouponList.value = true;
    availableCouponPageNum.value = 1;

    availableCouponList.value = await couponRepository.getCouponList(
      pageNum: 1,
      size: 7,
      language: languageServices.languageCodeSystem.value,
      state: 1,
    );

    if (availableCouponList.isEmpty) {
      isSeeMoreAvailableCouponList.value = false;
    }
  }

  Future<void> seeMoreAvailableCouponList() async {
    availableCouponPageNum.value += 1;

    var availableCouponList = await couponRepository.getCouponList(
      pageNum: availableCouponPageNum.value,
      language: languageServices.languageCodeSystem.value,
    );

    if (availableCouponList.isEmpty) {
      isSeeMoreAvailableCouponList.value = false;
    }

    this.availableCouponList.addAll(availableCouponList);
  }
}
