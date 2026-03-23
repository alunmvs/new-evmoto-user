import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../routes/app_pages.dart';

class HomeBookmarkLocationSubview extends GetView<HomeController> {
  const HomeBookmarkLocationSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Showcase.withWidget(
        targetPadding: EdgeInsets.symmetric(vertical: 16),
        disableBarrierInteraction: true,
        key: controller.savedLocationGlobalKey,
        onTargetClick: () {},
        disposeOnTap: false,
        targetBorderRadius: BorderRadius.circular(16),
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        container: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 45 * 3.1415926535 / 180,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .coachmarkTitle2 ??
                            "-",
                        style: controller.typographyServices.bodyLargeBold.value
                            .copyWith(),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .coachmarkDescription2 ??
                            "-",
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "2/5",
                            style: controller
                                .typographyServices
                                .captionLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey500
                                      .value,
                                ),
                          ),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                ShowcaseView.get().next();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .buttonNext1 ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
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
              ],
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 16),
              for (var savedAddress in controller.savedAddressList) ...[
                GestureDetector(
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    var isIntroductionDeliveryServiceShown =
                        prefs.getBool(
                          'is_introduction_delivery_service_shown',
                        ) ??
                        false;
                    if (isIntroductionDeliveryServiceShown == false) {
                      await Get.toNamed(Routes.INTRODUCTION_DELIVERY_SERVICE);
                      return;
                    }

                    await controller.refreshAll(firstInit: true);
                    if (controller.isActiveOrderListNotEmpty.value) {
                      await Get.toNamed(
                        Routes.RIDE_ORDER_DETAIL,
                        arguments: {
                          "order_id": controller.activeOrderList.first.orderId
                              .toString(),
                          "order_type":
                              controller.activeOrderList.first.orderType,
                        },
                      );
                      return;
                    }

                    await Get.toNamed(
                      Routes.CREATE_ORDER_RIDE,
                      arguments: {
                        "origin_address_name": savedAddress.addressName,
                        "origin_address": savedAddress.addressDetail,
                        "origin_latitude": savedAddress.latitude.toString(),
                        "origin_longitude": savedAddress.longitude.toString(),
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
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
                          savedAddress.addressType == 1
                              ? "assets/icons/icon_home.svg"
                              : savedAddress.addressType == 2
                              ? "assets/icons/icon_office.svg"
                              : "assets/icons/icon_pinpoint.svg",
                          width: 12,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          savedAddress.addressName ?? "-",
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
                ),
                SizedBox(width: 8),
              ],
              if (controller.isBookmarkHomeIsSet() == false) ...[
                GestureDetector(
                  onTap: () async {
                    await Get.toNamed(
                      Routes.SEARCH_ADDRESS,
                      arguments: {
                        "address_type": 1,
                        "tag": DateTime.now().millisecondsSinceEpoch.toString(),
                      },
                    );

                    await controller.refreshAll();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
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
                          "assets/icons/icon_home.svg",
                          width: 12,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .addLocationHome ??
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
              if (controller.isBookmarkCompanyIsSet() == false) ...[
                GestureDetector(
                  onTap: () async {
                    await Get.toNamed(
                      Routes.SEARCH_ADDRESS,
                      arguments: {
                        "address_type": 2,
                        "tag": DateTime.now().millisecondsSinceEpoch.toString(),
                      },
                    );

                    await controller.refreshAll();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
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
                          "assets/icons/icon_office.svg",
                          width: 12,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .addLocationOffice ??
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(
                    Routes.SEARCH_ADDRESS,
                    arguments: {
                      "address_type": 3,
                      "tag": DateTime.now().millisecondsSinceEpoch.toString(),
                    },
                  );

                  await controller.refreshAll();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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
                        "assets/icons/icon_add_square.svg",
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(width: 6),
                      Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .addLocationOther ??
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
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
