import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/setting_saved_location_controller.dart';

class SettingSavedLocationView extends GetView<SettingSavedLocationController> {
  const SettingSavedLocationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.settingSavedLocation ??
                "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        body: Stack(
          children: [
            Container(
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
            controller.isFetch.value
                ? Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                    ),
                  )
                : SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: () async {
                      await controller.getSavedAddressList();
                      controller.refreshController.refreshCompleted();
                    },
                    header: MaterialClassicHeader(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                    footer: ClassicFooter(
                      loadStyle: LoadStyle.HideAlways,
                      textStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                      canLoadingIcon: null,
                      loadingIcon: null,
                      idleIcon: null,
                      noMoreIcon: null,
                      failedIcon: null,
                    ),
                    enablePullDown: true,
                    enablePullUp: false,
                    onLoading: () async {
                      controller.refreshController.loadComplete();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            if (controller.savedAddressList.isEmpty) ...[
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .savedAddressNotFoundTitle ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .savedAddressNotFoundDescription ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    for (var savedAddress
                                        in controller.savedAddressList) ...[
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    savedAddress.addressType ==
                                                            1
                                                        ? "assets/icons/icon_home.svg"
                                                        : savedAddress
                                                                  .addressType ==
                                                              2
                                                        ? "assets/icons/icon_office.svg"
                                                        : "assets/icons/icon_pinpoint.svg",
                                                    width: 18,
                                                    height: 18,
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
                                                    savedAddress.addressName ??
                                                        "-",
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
                                                  SizedBox(height: 2),
                                                  Text(
                                                    savedAddress
                                                            .addressDetail ??
                                                        "-",
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
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () async {
                                                await controller
                                                    .onTapMoreOptions(
                                                      savedAddress:
                                                          savedAddress,
                                                    );
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                width: 24,
                                                height: 24,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/icon_three_dots_vertical.svg",
                                                      width: 4.5,
                                                      height: 21,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (controller.savedAddressList.last !=
                                          savedAddress) ...[
                                        Divider(
                                          height: 0,
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey200
                                              .value,
                                        ),
                                      ],
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
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          shadowColor: controller.themeColorServices.overlayDark100.value
              .withValues(alpha: 0.1),
          color: controller.themeColorServices.neutralsColorGrey0.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoaderElevatedButton(
                onPressed: () async {
                  await controller.onTapAddLocation();
                },
                buttonColor: controller.themeColorServices.primaryBlue.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_add_square.svg",
                      width: 12,
                      height: 12,
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                    ),
                    SizedBox(width: 6),
                    Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .addOtherAddress ??
                          "-",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
