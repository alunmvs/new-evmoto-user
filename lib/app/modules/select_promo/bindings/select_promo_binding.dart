import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';

import '../controllers/select_promo_controller.dart';

class SelectPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectPromoController>(
      () => SelectPromoController(couponRepository: CouponRepository()),
    );
  }
}
