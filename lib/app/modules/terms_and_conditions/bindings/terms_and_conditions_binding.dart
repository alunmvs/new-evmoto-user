import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';

import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionsController>(
      () => TermsAndConditionsController(
        agreementRepository: AgreementRepository(),
      ),
    );
  }
}
