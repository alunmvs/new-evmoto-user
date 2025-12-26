import 'package:get/get.dart';

import '../controllers/history_balance_detail_controller.dart';

class HistoryBalanceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceDetailController>(
      () => HistoryBalanceDetailController(),
    );
  }
}
