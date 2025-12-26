import 'package:get/get.dart';

import '../controllers/voucher_detail_controller.dart';

class VoucherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoucherDetailController>(
      () => VoucherDetailController(),
    );
  }
}
