import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/payment_repository.dart';

import '../controllers/history_balance_controller.dart';

class HistoryBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryBalanceController>(
      () => HistoryBalanceController(paymentRepository: PaymentRepository()),
    );
  }
}
