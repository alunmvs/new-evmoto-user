import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/controllers/setting_saved_location_controller.dart';

class SavedAddressCardSubView extends GetView<SettingSavedLocationController> {
  final SavedAddress savedAddress;
  const SavedAddressCardSubView({super.key, required this.savedAddress});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: controller.themeColorServices.sematicColorBlue100.value,
                borderRadius: BorderRadius.circular(8),
              ),
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
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    savedAddress.addressName ?? "-",
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    savedAddress.addressDetail ?? "-",
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                await controller.onTapMoreOptions(savedAddress: savedAddress);
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
    );
  }
}
