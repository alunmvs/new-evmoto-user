import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class EndPushDialog extends StatelessWidget {
  final int orderId;
  final int orderType;

  EndPushDialog({super.key, required this.orderId, required this.orderType});

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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Belum Mendapatkan Driver",
                      style: typographyServices.bodyLargeBold.value,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Maaf, pencarian driver memakan waktu lebih lama dari biasanya. Kamu bisa mencoba lagi atau menyesuaikan perjalananmu.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFFB3B3B3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            width: Get.width,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0XFFEB5757)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                var orderRideRepository = OrderRideRepository();
                                await orderRideRepository.cancelOrderRide(
                                  orderId: orderId.toString(),
                                  orderType: orderType,
                                  language:
                                      languageServices.languageCodeSystem.value,
                                  reason: null,
                                  remark: null,
                                );
                                Get.close(1);
                                Get.back();

                                SnackbarHelper.showSnackbarError(
                                  text:
                                      languageServices
                                          .language
                                          .value
                                          .snackbarCancelTransactionSuccess ??
                                      "-",
                                );
                              },
                              child: Text(
                                "Batalkan",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(color: Color(0XFFEB5757)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: LoaderElevatedButton(
                            onPressed: () async {
                              Get.close(1);
                            },
                            child: Text(
                              "Lanjutkan",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(color: Colors.white),
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
    );
  }
}
