import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

import '../controllers/ride_controller.dart';

class RideView extends GetView<RideController> {
  const RideView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Image.asset(
              "assets/images/img_example_maps.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            if (controller.status.value == "fill_origin_and_destination") ...[
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 96,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0XFFFFFFFF),
                            Color(0XFFFFFFFF).withValues(alpha: 0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Container(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Mau Kemana Hari Ini?",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey700
                                              .value,
                                        ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_maps.svg",
                                          width: 16,
                                          height: 16,
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Pilih Lewat Peta",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey700
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue600
                                                .value,
                                          ),
                                      focusNode: controller.focusNodeOrigin,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        hintText: 'Masukkan lokasi penjemputan',
                                        hintStyle: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                        fillColor:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isOriginHasPrimaryFocus
                                                        .value ==
                                                    true
                                            ? Colors.white
                                            : Colors.transparent,
                                        filled: true,
                                        border:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isOriginHasPrimaryFocus
                                                        .value ==
                                                    true
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              )
                                            : InputBorder.none,
                                        enabledBorder:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isOriginHasPrimaryFocus
                                                        .value ==
                                                    true
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              )
                                            : InputBorder.none,
                                        focusedBorder:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isOriginHasPrimaryFocus
                                                        .value ==
                                                    true
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              )
                                            : InputBorder.none,
                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 24,
                                        ),
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 12),
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_origin.svg",
                                                    width: 20,
                                                    height: 20,
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorSlate700
                                                        .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      style: controller
                                          .typographyServices
                                          .captionLargeRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorBlue600
                                                .value,
                                          ),
                                      focusNode:
                                          controller.focusNodeDestination,
                                      readOnly:
                                          controller.isLatLngOriginFilled() ==
                                          false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        hintText: 'Masukkan lokasi tujuan',
                                        hintStyle: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey500
                                                  .value,
                                            ),
                                        fillColor:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isDestinationHasPrimaryFocus
                                                        .value ==
                                                    false
                                            ? Colors.transparent
                                            : controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                        filled: true,
                                        border:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isDestinationHasPrimaryFocus
                                                        .value ==
                                                    false
                                            ? InputBorder.none
                                            : OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              ),
                                        enabledBorder:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isDestinationHasPrimaryFocus
                                                        .value ==
                                                    false
                                            ? InputBorder.none
                                            : OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              ),
                                        focusedBorder:
                                            controller.isLatLngOriginFilled() ==
                                                    false ||
                                                controller
                                                        .isDestinationHasPrimaryFocus
                                                        .value ==
                                                    false
                                            ? InputBorder.none
                                            : OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                              ),
                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 24,
                                        ),
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 12),
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_pinpoint.svg",
                                                    width: 18,
                                                    height: 21,
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorRed400
                                                        .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 16),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
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
                                                "assets/icons/icon_home.svg",
                                                height: 12,
                                                width: 12,
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Tambah Rumah",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
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
                                                "assets/icons/icon_office.svg",
                                                height: 14,
                                                width: 10,
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Tambah Kantor",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
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
                                                "assets/icons/icon_add_square.svg",
                                                height: 12,
                                                width: 12,
                                                color: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Lokasi Lainnya",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey500
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            DashedLine(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey200
                                  .value,
                            ),
                            SizedBox(height: 2),
                            if (controller.isLatLngOriginFilled() == false ||
                                controller.isOriginHasPrimaryFocus.value ==
                                    true) ...[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0; i < 10; i++) ...[
                                        GestureDetector(
                                          onTap: () {
                                            controller.latitudeOrigin.value =
                                                "6";
                                            controller.longitudeOrigin.value =
                                                "7";
                                            controller.focusNodeDestination
                                                .requestFocus();
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(
                                              bottom: 8,
                                              top: 14,
                                              left: 16,
                                              right: 16,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue100
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_pinpoint.svg",
                                                        width: 13.5,
                                                        height: 15.75,
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorBlue500
                                                            .value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextHighlight(
                                                        text:
                                                            "Jalan Kencana Permai",
                                                        words: controller
                                                            .highlightedWordTitleAddressOrigin,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value,
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 4),
                                                      // keterangan : untuk jarak seperti "27km ⬩ " perlu ditambah pada words ketika fetch API menggunakan Regex karena jaraknya dinamis
                                                      TextHighlight(
                                                        text:
                                                            "27km ⬩ Jl.Kencana Permai, RT008/RW006, Jatirasa, Kec. Jatiasih, Bekasi Kota, Jawa Barat 17423, Indonesia",
                                                        words: controller
                                                            .highlightedWordAddressOrigin,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey500
                                                                  .value,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                      ],
                                      SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (controller.isDestinationHasPrimaryFocus.value ==
                                true) ...[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0; i < 10; i++) ...[
                                        GestureDetector(
                                          onTap: () {
                                            controller
                                                    .latitudeDestination
                                                    .value =
                                                "6";
                                            controller
                                                    .longitudeDestination
                                                    .value =
                                                "7";
                                            controller.status.value =
                                                "confirm_origin";
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(
                                              bottom: 8,
                                              top: 14,
                                              left: 16,
                                              right: 16,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue100
                                                        .value,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_pinpoint.svg",
                                                        width: 13.5,
                                                        height: 15.75,
                                                        color: controller
                                                            .themeColorServices
                                                            .sematicColorBlue500
                                                            .value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextHighlight(
                                                        text:
                                                            "Jalan Kencana Permai",
                                                        words: controller
                                                            .highlightedWordTitleAddressOrigin,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value,
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 4),
                                                      // keterangan : untuk jarak seperti "27km ⬩ " perlu ditambah pada words ketika fetch API menggunakan Regex karena jaraknya dinamis
                                                      TextHighlight(
                                                        text:
                                                            "27km ⬩ Jl.Kencana Permai, RT008/RW006, Jatirasa, Kec. Jatiasih, Bekasi Kota, Jawa Barat 17423, Indonesia",
                                                        words: controller
                                                            .highlightedWordAddressOrigin,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey500
                                                                  .value,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                      ],
                                      SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (controller.status.value == "confirm_origin") ...[
              Container(
                height: 96,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFFFFFFFF),
                      Color(0XFFFFFFFF).withValues(alpha: 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.status.value =
                                  "fill_origin_and_destination";
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
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
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Penjemputan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_origin.svg",
                                          width: 20,
                                          height: 20,
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
                                          "Jalan Haji Jian nomor 2B",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                        ),
                                        Text(
                                          "Jalan Haji Jian nomor 2B, Cilandak, Jakarta Selatan...",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          DashedLine(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 46,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.status.value = "checkout";
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Konfirmasi",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (controller.status.value == "checkout") ...[
              Container(
                height: 96,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFFFFFFFF),
                      Color(0XFFFFFFFF).withValues(alpha: 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.status.value = "confirm_origin";
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
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
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Penjemputan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_origin.svg",
                                          width: 20,
                                          height: 20,
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
                                          "Jalan Haji Jian nomor 2B",
                                          style: controller
                                              .typographyServices
                                              .bodySmallBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                        ),
                                        Text(
                                          "Jalan Haji Jian nomor 2B, Cilandak, Jakarta Selatan...",
                                          style: controller
                                              .typographyServices
                                              .captionLargeRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorSlate800
                                                    .value,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          DashedLine(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller
                                            .onTapSelectPaymentBottomSheet();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_wallet.svg",
                                                    width: 8,
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Saldo ECGO",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallBold
                                                  .value,
                                            ),
                                            SizedBox(width: 4),
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
                                                    "assets/icons/icon_arrow_down.svg",
                                                    width: 8.67,
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.SELECT_PROMO);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_discount.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Promo",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallBold
                                                  .value,
                                            ),
                                            SizedBox(width: 4),
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
                                                    "assets/icons/icon_arrow_down.svg",
                                                    width: 8.67,
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 46,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.status.value =
                                      "finding_driver_nearby";
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Pesan EV Moto",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (controller.status.value == "finding_driver_nearby") ...[
              Container(
                height: 96,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFFFFFFFF),
                      Color(0XFFFFFFFF).withValues(alpha: 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.status.value = "checkout";
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
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
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  constraints: BoxConstraints(minHeight: 262),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 61,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_location_time.svg",
                                          width: 19.89,
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Drivermu sampai dalam",
                                    style: controller
                                        .typographyServices
                                        .bodySmallBold
                                        .value,
                                  ),
                                  Spacer(),
                                  SizedBox(width: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorGreen100
                                          .value,
                                      border: Border.all(
                                        color: controller
                                            .themeColorServices
                                            .sematicColorGreen200
                                            .value,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "15 Menit",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .sematicColorGreen500
                                                .value,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 45,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,

                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Container(
                                      width: 33,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey300
                                            .value,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey300
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_profile.svg",
                                              width: 48,
                                              height: 48,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Franky Fransisco Marlissa",
                                                  style: controller
                                                      .typographyServices
                                                      .bodyLargeBold
                                                      .value,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 16,
                                                            width: 16,
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/icons/icon_star.svg",
                                                                  width: 13,
                                                                  height: 12,
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .sematicColorYellow400
                                                                      .value,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 2),
                                                          Text(
                                                            "5.00",
                                                            style: controller
                                                                .typographyServices
                                                                .bodySmallBold
                                                                .value
                                                                .copyWith(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .neutralsColorGrey700
                                                                      .value,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: controller
                                                              .themeColorServices
                                                              .neutralsColorGrey200
                                                              .value,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "B 3457 KZE",
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value
                                                            .copyWith(
                                                              color: controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey700
                                                                  .value,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    DashedLine(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey300
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 32,
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 46,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: controller
                                                .themeColorServices
                                                .primaryBlue
                                                .value,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
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
                                                    "assets/icons/icon_phone.svg",
                                                    width: 11.18,
                                                    height: 12,
                                                    color: controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Telepon",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
