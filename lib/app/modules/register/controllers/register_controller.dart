import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterController extends GetxController {
  final formGroup = FormGroup({
    "mobile_number": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "full_name": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "otp_code": FormControl<String>(
      validators: <Validator>[Validators.required],
    ),
    "referral_code": FormControl<String>(validators: <Validator>[]),
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

  Future<void> onTapRequestOTP() async {}

  Future<void> onTapResendOTP() async {}

  Future<void> onTapSubmit() async {}
}
