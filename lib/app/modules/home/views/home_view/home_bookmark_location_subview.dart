import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/utils/order_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import '../../../../routes/app_pages.dart';

class HomeBookmarkLocationSubview extends GetView<HomeController> {
  const HomeBookmarkLocationSubview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16),
            for (var savedAddress in controller.savedAddressList) ...[
              GestureDetector(
                onTap: () async {
                  await controller.refreshAll(firstInit: true);

                  if (controller.isActiveOrderListNotEmpty.value) {
                    try {
                      var isCancelled = await isOrderHasBeenCancelled(
                        orderId: controller.activeOrderList.first.orderId
                            .toString(),
                        orderType: controller.activeOrderList.first.orderType!,
                      );

                      if (isCancelled == true) {
                        SnackbarHelper.showSnackbarError(
                          text:
                              controller
                                  .languageServices
                                  .language
                                  .value
                                  .orderHasBeenCancelled ??
                              "-",
                        );
                        await controller.refreshAll(firstInit: false);
                        return;
                      }
                    } on DioException catch (e) {
                      SnackbarHelper.showSnackbarError(
                        text: e.error.toString(),
                      );
                    } catch (e) {
                      SnackbarHelper.showSnackbarError(text: e.toString());
                    }

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

                  await Future.doWhile(() async {
                    await Future.delayed(Duration(milliseconds: 100));
                    return controller.currentAddressIsLoading.value;
                  });

                  await Get.toNamed(
                    Routes.CREATE_ORDER_RIDE,
                    arguments: {
                      "origin_address_name":
                          controller.currentGeocodingAddress.value.name,
                      "origin_address":
                          controller.currentGeocodingAddress.value.address,
                      "origin_latitude": controller.currentLatitude.value
                          .toString(),
                      "origin_longitude": controller.currentLongitude.value
                          .toString(),
                      "destination_address_name": savedAddress.addressName,
                      "destination_address": savedAddress.addressDetail,
                      "destination_latitude": savedAddress.latitude.toString(),
                      "destination_longitude": savedAddress.longitude
                          .toString(),
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
                await Get.toNamed(Routes.ADD_EDIT_ADDRESS_OTHER);
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
    );
  }
}
