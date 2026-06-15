import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';

class PaymentMethodGopayUnbindConfirmationDialog extends StatelessWidget {
  final Future<void> Function() onTapConfirm;

  PaymentMethodGopayUnbindConfirmationDialog({
    super.key,
    required this.onTapConfirm,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: MediaQuery.of(
                  navigatorKey.currentContext!,
                ).size.height,
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Batalkan Pembayaran GoPay",
                            style: typographyServices.bodyLargeBold.value,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 24,
                              height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_close.svg",
                                    width: 14,
                                    height: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/img_payment_method_gopay_unbind.png",
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Jika dibatalkan, Metode Pembayaran GoPay tidak dapat digunakan. Aktifkan kembali jika digunakan sebagai metode utama.",
                        style: typographyServices.bodySmallRegular.value
                            .copyWith(color: Color(0XFFB3B3B3)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0XFFFFF0F0),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: themeColorServices.overlayDark200.value
                                  .withValues(alpha: 0.08),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_alert.svg",
                                  width: 15.2,
                                  height: 13.47,
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Setelah dibatalkan, metode pembayaran tidak dapat digunakan kembali.",
                                style: typographyServices
                                    .captionLargeRegular
                                    .value
                                    .copyWith(color: Color(0XFFCD0000)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      LoaderElevatedButton(
                        buttonColor: themeColorServices.redColor.value,
                        onPressed: () async {
                          await onTapConfirm();
                        },
                        child: Text(
                          "Ya, Batalkan",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 46,
                        width: Get.width,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0XFFDFDFDF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            Get.close(1);
                          },
                          child: Text(
                            "Kembali",
                            style: typographyServices.bodyLargeRegular.value
                                .copyWith(color: Color(0XFFDFDFDF)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
