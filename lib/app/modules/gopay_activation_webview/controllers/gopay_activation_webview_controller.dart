import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/dialogs/payment_method_gopay_success_bind_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GopayActivationWebviewController extends GetxController {
  final GopayPaymentRepository gopayPaymentRepository;

  GopayActivationWebviewController({
    required this.gopayPaymentRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final activationUrl = "".obs;
  final isLoading = true.obs;

  late final WebViewController webViewController;
  Timer? _linkStatusTimer;
  var _isSuccessDialogShown = false;

  @override
  void onInit() {
    super.onInit();
    activationUrl.value = Get.arguments?['activation_url'] ?? "";

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            isLoading.value = true;
          },
          onPageFinished: (_) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(activationUrl.value));

    _startLinkStatusPolling();
  }

  void _startLinkStatusPolling() {
    _linkStatusTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkLinkStatus(),
    );
  }

  Future<void> _checkLinkStatus() async {
    if (_isSuccessDialogShown || isClosed) return;

    try {
      final linkStatus = await gopayPaymentRepository.getGopayLinkStatus();
      if (linkStatus.linked == true) {
        _isSuccessDialogShown = true;
        _linkStatusTimer?.cancel();
        await _showSuccessDialog();
      }
    } on DioException {
      // Keep polling until link succeeds or user leaves the page.
    } catch (_) {
      // Keep polling until link succeeds or user leaves the page.
    }
  }

  Future<void> _showSuccessDialog() async {
    await Get.dialog(
      PaymentMethodGopaySuccessBindDialog(),
      barrierDismissible: true,
    );
    if (isClosed) return;
    _onDismissSuccessDialog();
  }

  void _onDismissSuccessDialog() {
    Get.back();
    Get.back();
  }

  @override
  void onClose() {
    _linkStatusTimer?.cancel();
    super.onClose();
  }
}
