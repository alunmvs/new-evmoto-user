import 'package:get/get.dart';

import '../controllers/select_promo_controller.dart';

class SelectPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectPromoController>(
      () => SelectPromoController(),
    );
  }
}
