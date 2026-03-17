import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';

import '../controllers/voucher_list_controller.dart';

class VoucherListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoucherListController>(
      () => VoucherListController(couponRepository: CouponRepository()),
    );
  }
}
