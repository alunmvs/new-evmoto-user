import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class RideController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final focusNodeOrigin = FocusNode();
  final focusNodeDestination = FocusNode();

  final latitudeOrigin = "".obs;
  final longitudeOrigin = "".obs;
  final latitudeDestination = "".obs;
  final longitudeDestination = "".obs;

  final keywordOrigin = "".obs;
  late TextEditingController textEditingControllerOrigin;

  final highlightedWordTitleAddressOrigin = <String, HighlightedWord>{}.obs;
  final highlightedWordAddressOrigin = <String, HighlightedWord>{}.obs;

  final keywordDestination = "".obs;
  late TextEditingController textEditingControllerDestination;

  final highlightedWordTitleAddressDestination =
      <String, HighlightedWord>{}.obs;
  final highlightedWordAddressDestination = <String, HighlightedWord>{}.obs;

  final isOriginHasPrimaryFocus = false.obs;
  final isDestinationHasPrimaryFocus = false.obs;

  final selectedPaymentMethod = "ecgo_wallet".obs;

  final status = "fill_origin_and_destination".obs;

  @override
  void onInit() {
    super.onInit();

    focusNodeOrigin.addListener(() {
      isOriginHasPrimaryFocus.value = focusNodeOrigin.hasPrimaryFocus;
      isOriginHasPrimaryFocus.refresh();
    });
    focusNodeDestination.addListener(() {
      isDestinationHasPrimaryFocus.value = focusNodeDestination.hasPrimaryFocus;
      isDestinationHasPrimaryFocus.refresh();
    });

    focusNodeOrigin.requestFocus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isLatLngOriginFilled() {
    return latitudeOrigin.value != "" && longitudeOrigin.value != "";
  }

  bool isLatLngDestinationFilled() {
    return latitudeDestination.value != "" && longitudeDestination.value != "";
  }

  void onTapSelectPaymentBottomSheet() async {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pilih Pembayaran",
                          style: typographyServices.bodyLargeBold.value,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 24,
                            width: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_close.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: themeColorServices.neutralsColorGrey200.value,
                  ),
                  SizedBox(height: 16),
                  RadioGroup(
                    onChanged: (value) {
                      selectedPaymentMethod.value = value!;
                    },
                    groupValue: selectedPaymentMethod.value,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: themeColorServices
                                          .neutralsColorGrey100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_wallet.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Saldo ECGO",
                                          style: typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Rp150.000",
                                          style: typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Radio(
                                    value: "ecgo_wallet",
                                    activeColor:
                                        themeColorServices.primaryBlue.value,
                                    backgroundColor:
                                        selectedPaymentMethod.value ==
                                            "ecgo_wallet"
                                        ? WidgetStateProperty.all(
                                            themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeColorServices
                                    .sematicColorBlue100
                                    .value,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: themeColorServices
                                                .neutralsColorGrey100
                                                .value,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/logos/logo_dana.svg",
                                                width: 16,
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Saldo DANA",
                                                style: typographyServices
                                                    .bodySmallBold
                                                    .value
                                                    .copyWith(
                                                      color: themeColorServices
                                                          .neutralsColorGrey700
                                                          .value,
                                                    ),
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/icon_alert.svg",
                                                          width: 12,
                                                          height: 12,
                                                          color: themeColorServices
                                                              .sematicColorYellow400
                                                              .value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    "Rp5.000",
                                                    style: typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: themeColorServices
                                                              .sematicColorYellow400
                                                              .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Radio(
                                          value: "dana",
                                          activeColor: themeColorServices
                                              .primaryBlue
                                              .value,
                                          enabled: false,
                                          backgroundColor:
                                              selectedPaymentMethod.value ==
                                                  "dana"
                                              ? WidgetStateProperty.all(
                                                  themeColorServices
                                                      .sematicColorBlue100
                                                      .value,
                                                )
                                              : WidgetStateProperty.all(
                                                  themeColorServices
                                                      .neutralsColorGrey300
                                                      .value,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      left: 12,
                                      right: 12,
                                      bottom: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Tap disini untuk topup",
                                          style: typographyServices
                                              .captionLargeBold
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_arrow_right.svg",
                                                width: 8.67,
                                                height: 5,
                                                color: themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: themeColorServices
                                          .neutralsColorGrey100
                                          .value,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_cash.svg",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cash",
                                          style: typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          "Siapkan uang pas untuk perjalananmu",
                                          style: typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Radio(
                                    value: "cash",
                                    activeColor:
                                        themeColorServices.primaryBlue.value,
                                    backgroundColor:
                                        selectedPaymentMethod.value == "cash"
                                        ? WidgetStateProperty.all(
                                            themeColorServices
                                                .sematicColorBlue100
                                                .value,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
