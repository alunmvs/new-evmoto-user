import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/payment_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DepositBalancePaymentWebviewController extends GetxController {
  final PaymentRepository paymentRepository;

  DepositBalancePaymentWebviewController({required this.paymentRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final homeController = Get.find<HomeController>();

  final webViewController = WebViewController();

  final redirectUrl = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    redirectUrl.value = Get.arguments['redirect_url'] ?? "";
    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webViewController.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) async {
          var uri = Uri.parse(request.url);
          try {
            await paymentRepository.redirectUrlDepositBalance(
              orderId: uri.queryParameters['order_id'].toString(),
              statusCode: uri.queryParameters['status_code'].toString(),
              transactionStatus: uri.queryParameters['transaction_status']
                  .toString(),
            );
          } catch (e) {}
          await homeController.getUserInfo();
          Get.back();
          Get.back();
          final SnackBar snackBar = SnackBar(
            behavior: SnackBarBehavior.fixed,
            backgroundColor: themeColorServices.sematicColorGreen400.value,
            content: Text(
              languageServices.language.value.snackbarRechargeSuccess ?? "-",
              style: typographyServices.bodySmallRegular.value.copyWith(
                color: themeColorServices.neutralsColorGrey0.value,
              ),
            ),
          );
          rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
          return NavigationDecision.prevent;
        },
      ),
    );

    await webViewController.loadRequest(Uri.parse(redirectUrl.value));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> showDialogBackButton() async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Apakah Anda yakin ingin membatalkan transaksi isi ulang saldo?",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Tutup",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              width: Get.width,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.close(1);
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColorServices
                                      .sematicColorRed400
                                      .value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Batalkan",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
