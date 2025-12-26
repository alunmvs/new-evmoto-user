import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class VoucherDetailController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final couponDetail = Coupon().obs;

  final isOpenTermAndCondition = true.obs;
  final isSelectCoupon = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    couponDetail.value = Get.arguments['coupon_detail'];
    isSelectCoupon.value = Get.arguments['is_select_coupon'] ?? false;
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
}
