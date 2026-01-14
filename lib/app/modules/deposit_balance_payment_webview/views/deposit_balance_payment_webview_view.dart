import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/main.dart';
import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewView
    extends GetView<DepositBalancePaymentWebviewController> {
  const DepositBalancePaymentWebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop == false) {
          await controller.showDialogBackButton();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.showDialogBackButton();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    border: Border.all(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey300
                          .value,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_back.svg",
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(controller.redirectUrl.value),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useOnDownloadStart: true,
          ),
          onWebViewCreated: (controller) {},
          onDownloadStartRequest:
              (webviewController, downloadStartRequest) async {
                var uri = downloadStartRequest.url;

                if (uri.scheme == "blob") {}
              },
          shouldOverrideUrlLoading:
              (webviewController, navigationAction) async {
                final uri = navigationAction.request.url!;

                if (uri.scheme == "intent" ||
                    !["http", "https"].contains(uri.scheme)) {
                  await controller.handleIntent(uri.toString());
                  return NavigationActionPolicy.CANCEL;
                }

                if (uri.queryParameters['action'].toString() == "back") {
                  await controller.showDialogBackButton();
                  return NavigationActionPolicy.CANCEL;
                }

                if (uri.queryParameters['transaction_status'].toString() ==
                    "settlement") {
                  Get.back();
                  Get.back();
                  final SnackBar snackBar = SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor: controller
                        .themeColorServices
                        .sematicColorGreen400
                        .value,
                    content: Text(
                      "Saldo berhasil ditambah",
                      style: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                    ),
                  );
                  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                  return NavigationActionPolicy.CANCEL;
                } else if (uri.queryParameters['action'].toString() ==
                    "abandoned") {
                  Get.back();
                  final SnackBar snackBar = SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    backgroundColor:
                        controller.themeColorServices.sematicColorRed400.value,
                    content: Text(
                      "Transaksi kedaluwarsa",
                      style: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                          ),
                    ),
                  );
                  rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
        ),
      ),
    );
  }
}
