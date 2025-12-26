import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/payment_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';

import '../controllers/deposit_balance_controller.dart';

class DepositBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositBalanceController>(
      () => DepositBalanceController(
        paymentRepository: PaymentRepository(),
        userRepository: UserRepository(),
      ),
    );
  }
}
