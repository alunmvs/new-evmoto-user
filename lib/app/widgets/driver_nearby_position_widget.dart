import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';

class DriverNearbyPositionWidget extends StatelessWidget {
  final DriverNearby driverNearby;
  final bool isDisplayDistance;

  DriverNearbyPositionWidget({
    super.key,
    required this.driverNearby,
    this.isDisplayDistance = true,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isDisplayDistance == true) ...[
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0XFFEEF6FF),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: themeColorServices.overlayDark100.value.withValues(
                    alpha: 0.13,
                  ),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/icons/icon_pinpoint_primary_blue.svg"),
                SizedBox(width: 2),
                Text(
                  formatDistance(driverNearby.distance ?? 0.0),
                  style: typographyServices.captionSmallBold.value,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
        SvgPicture.asset("assets/icons/icon_driver.svg", width: 26),
      ],
    );
  }
}
