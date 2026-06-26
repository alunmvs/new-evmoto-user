import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';

import '../controllers/gopay_activation_webview_controller.dart';

class GopayActivationWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GopayActivationWebviewController>(
      () => GopayActivationWebviewController(
        gopayPaymentRepository: GopayPaymentRepository(),
      ),
    );
  }
}
