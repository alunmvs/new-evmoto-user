import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(agreementRepository: AgreementRepository()),
    );
  }
}
