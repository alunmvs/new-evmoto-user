import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class OrderCheckoutAdditionalCancellationFeeBottomsheet
    extends StatelessWidget {
  OrderCheckoutAdditionalCancellationFeeBottomsheet({super.key});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Material(
            color: themeColorServices.neutralsColorGrey0.value,
            child: Container(
              padding: EdgeInsets.all(16),
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/img_order_checkout_additional_cancellation_fee.png",
                        width: 52,
                        height: 52,
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
                  Text(
                    "Informasi Biaya Tambahan",
                    style: typographyServices.bodyLargeBold.value.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Karena terdapat pembatalan pada perjalanan sebelumnya, biaya tambahan akan disertakan pada pesanan ini.",
                    style: typographyServices.bodySmallRegular.value.copyWith(
                      color: Color(0XFFB3B3B3),
                    ),
                  ),
                  SizedBox(height: 14),
                  DashedLine(color: Color(0XFFE9E9E9)),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pembatalan Pesanan",
                            style: typographyServices.bodySmallRegular.value,
                          ),
                          SizedBox(height: 2),
                          Text(
                            "21 Mei 2026 ⬩ 08:22",
                            style: typographyServices.captionLargeRegular.value
                                .copyWith(color: Color(0XFFB3B3B3)),
                          ),
                        ],
                      ),
                      Text(
                        "Rp2.000",
                        style: typographyServices.bodyLargeBold.value,
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  DashedLine(color: Color(0XFFE9E9E9)),
                  SizedBox(height: 25),
                  LoaderElevatedButton(
                    onPressed: () async {},
                    child: Text(
                      "Lanjutkan Pemesanan",
                      style: typographyServices.bodyLargeBold.value.copyWith(
                        color: themeColorServices.neutralsColorGrey0.value,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
