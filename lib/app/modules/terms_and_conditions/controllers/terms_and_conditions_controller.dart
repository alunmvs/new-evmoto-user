import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/agreement_model.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class TermsAndConditionsController extends GetxController {
  final AgreementRepository agreementRepository;

  TermsAndConditionsController({required this.agreementRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final agreement = Agreement().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getTermsAndConditionsAgreement();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getTermsAndConditionsAgreement() async {
    agreement.value = await agreementRepository.getAgreementDetail(
      language: languageServices.languageCodeSystem.value,
      userType: 1,
      type: 2,
    );
  }
}
