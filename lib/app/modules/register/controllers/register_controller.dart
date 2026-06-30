import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final formGroup = FormGroup({
    "mobile_number": FormControl<String>(
      validators: <Validator>[
        Validators.required,
        Validators.pattern(r'^8.*'),
        Validators.minLength(8),
        Validators.maxLength(15),
      ],
    ),
    "full_name": FormControl<String>(
      validators: <Validator>[Validators.required, Validators.maxLength(20)],
    ),
    "otp_code": FormControl<String>(
      validators: <Validator>[Validators.required, Validators.maxLength(4)],
    ),
    "referral_code": FormControl<String>(
      validators: <Validator>[Validators.maxLength(8)],
    ),
  });

  final isFetch = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onTapRequestOTP() async {
    if (formGroup.control("mobile_number").valid == false) {
      SnackbarHelper.showSnackbarError(
        text: "Silahkan masukan nomor telepon untuk mendapatkan OTP",
      );
    }
  }

  Future<void> onTapResendOTP() async {
    if (formGroup.control("mobile_number").valid == false) {
      SnackbarHelper.showSnackbarError(
        text: "Silahkan masukan nomor telepon untuk mendapatkan OTP",
      );
    }
  }

  Future<void> onTapSubmit() async {
    Get.toNamed(Routes.REGISTER_SUCCESS);
  }
}
