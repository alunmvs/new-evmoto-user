import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';

import '../controllers/promotion_controller.dart';

class PromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromotionController>(
      () => PromotionController(couponRepository: CouponRepository()),
    );
  }
}
