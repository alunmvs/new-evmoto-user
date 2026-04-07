import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';

import '../../../../routes/app_pages.dart';

class CreateOrderRideSavedAddressSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideSavedAddressSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var savedAddress in controller.savedAddressList) ...[
            GestureDetector(
              onTap: () async {
                await controller.onTapSavedLocation(savedAddress: savedAddress);
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
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            savedAddress.addressType == 1
                                ? "assets/icons/icon_home.svg"
                                : savedAddress.addressType == 2
                                ? "assets/icons/icon_office.svg"
                                : "assets/icons/icon_pinpoint.svg",
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              controller.themeColorServices.primaryBlue.value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
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
                await controller.getSavedAddressList();
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
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_home.svg",
                            height: 12,
                            width: 12,
                            colorFilter: ColorFilter.mode(
                              controller.themeColorServices.primaryBlue.value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
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
                await controller.getSavedAddressList();
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
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_office.svg",
                            height: 14,
                            width: 10,
                            colorFilter: ColorFilter.mode(
                              controller.themeColorServices.primaryBlue.value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
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
              await controller.getSavedAddressList();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color:
                      controller.themeColorServices.neutralsColorGrey200.value,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_add_square.svg",
                          height: 12,
                          width: 12,
                          colorFilter: ColorFilter.mode(
                            controller.themeColorServices.primaryBlue.value,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
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
    );
  }
}
