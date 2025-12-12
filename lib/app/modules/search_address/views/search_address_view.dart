import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/search_address_controller.dart';

class SearchAddressView extends GetView<SearchAddressController> {
  const SearchAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.addressType.value == "home"
                ? "Tambah Rumah"
                : controller.addressType.value == "office"
                ? "Tambah Kantor"
                : "Tambah Lokasi Lainnya",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 375 / 96,
                  child: Container(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isFetch.value) ...[
              Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              ),
            ],
            if (controller.isFetch.value == false) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.isDisplaySearchAddressPinnedTop.value ==
                      true) ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
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
                          Text(
                            controller.addressType.value == "home"
                                ? "Masukkan Alamat Rumah"
                                : controller.addressType.value == "office"
                                ? "Masukkan Alamat Kantor"
                                : "Masukkan Alamat",
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                          SizedBox(height: 4),
                          TextField(
                            controller: controller.textEditingController,
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              hintText: "Masukkan Alamat Kamu",
                              hintStyle: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().slide(
                      begin: Offset(0, -1),
                      end: Offset(0, 0),
                      curve: Curves.easeInOut,
                      duration: 500.ms,
                    ),
                  ],
                  Expanded(
                    child: RefreshIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                      backgroundColor: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      onRefresh: () async {
                        await controller.requestLocation();
                        await controller.getPlaceLocationList(
                          keyword: controller.keyword.value,
                        );
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .sematicColorBlue100
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
                                            controller.addressType.value ==
                                                    "home"
                                                ? "assets/icons/icon_home.svg"
                                                : controller
                                                          .addressType
                                                          .value ==
                                                      "office"
                                                ? "assets/icons/icon_office.svg"
                                                : "assets/icons/icon_pinpoint.svg",
                                            width: 18,
                                            height: 18,
                                            color: controller
                                                .themeColorServices
                                                .primaryBlue
                                                .value,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      controller.addressType.value == "home"
                                          ? "Masukkan Alamat Rumah"
                                          : controller.addressType.value ==
                                                "office"
                                          ? "Masukkan Alamat Kantor"
                                          : "Masukkan Alamat",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                    ),
                                    SizedBox(height: 4),
                                    VisibilityDetector(
                                      key: Key('search-address'),
                                      onVisibilityChanged: (info) {
                                        var visiblePercentage =
                                            info.visibleFraction * 100;
                                        if (visiblePercentage <= 50.0) {
                                          controller
                                                  .isDisplaySearchAddressPinnedTop
                                                  .value =
                                              true;
                                        } else {
                                          controller
                                                  .isDisplaySearchAddressPinnedTop
                                                  .value =
                                              false;
                                        }
                                      },
                                      child: TextField(
                                        controller:
                                            controller.textEditingController,
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          hintText: "Masukkan Alamat Kamu",
                                          hintStyle: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey400
                                                    .value,
                                              ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey400
                                                  .value,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 2),
                                      for (var googlePlaceTextSearch
                                          in controller
                                              .googlePlaceTextSearchList) ...[
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.ADD_EDIT_ADDRESS,
                                              arguments: {
                                                "address_type": controller
                                                    .addressType
                                                    .value,
                                                "google_place_text_search":
                                                    googlePlaceTextSearch,
                                              },
                                            );
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 14,
                                              bottom: 14,
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
                                                          6,
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
                                                            .primaryBlue
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
                                                            googlePlaceTextSearch
                                                                .name ??
                                                            "-",
                                                        words: controller
                                                            .highlightedWordTitleAddress,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value,
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                      SizedBox(height: 4),
                                                      TextHighlight(
                                                        text:
                                                            "${controller.getDistanceString(googlePlaceTextSearch: googlePlaceTextSearch)} ⬩ ${googlePlaceTextSearch.formattedAddress}",
                                                        words: controller
                                                            .highlightedWordAddress,
                                                        textStyle: controller
                                                            .typographyServices
                                                            .captionLargeRegular
                                                            .value,
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
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
