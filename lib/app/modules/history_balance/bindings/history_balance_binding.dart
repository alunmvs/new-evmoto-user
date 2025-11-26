import 'package:get/get.dart';

import '../controllers/history_balance_controller.dart';

class HistoryBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceController>(
      () => HistoryBalanceController(),
    );
  }
}
