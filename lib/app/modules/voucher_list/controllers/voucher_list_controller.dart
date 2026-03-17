import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class VoucherListController extends GetxController {
  final CouponRepository couponRepository;

  VoucherListController({required this.couponRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final voucherList = <Coupon>[].obs;
  final isSeeMoreVoucherList = true.obs;

  final pageNum = 1.obs;
  final size = 10.obs;

  final selectedIndex = 1.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getVoucherList();
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

  Future<void> getVoucherList() async {
    pageNum.value = 1;
    isSeeMoreVoucherList.value = true;

    voucherList.value = await couponRepository.getCouponList(
      pageNum: pageNum.value,
      size: size.value,
      language: languageServices.languageCodeSystem.value,
      state: selectedIndex.value,
    );

    isSeeMoreVoucherList.value = voucherList.isNotEmpty;
  }

  Future<void> seeMoreVoucherList() async {
    pageNum.value += 1;

    var voucherList = await couponRepository.getCouponList(
      pageNum: pageNum.value,
      size: size.value,
      language: languageServices.languageCodeSystem.value,
      state: selectedIndex.value,
    );

    isSeeMoreVoucherList.value = voucherList.isNotEmpty;
  }
}
