import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view/home_bookmark_location_subview.dart';

class HomeShortcutSubView extends GetView<HomeController> {
  const HomeShortcutSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: controller.themeColorServices.overlayDark200.value
                .withValues(alpha: 0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () async {
                await controller.onTapWhereAreYouGoingToday();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      controller.themeColorServices.neutralsColorGrey100.value,
                  border: Border.all(
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey300
                        .value,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_pinpoint_red.svg",
                      width: 18,
                      height: 21,
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        controller
                                .languageServices
                                .language
                                .value
                                .homeRideReadyToGoHint ??
                            "-",
                        style: controller.typographyServices.bodyLargeBold.value
                            .copyWith(color: Color(0XFF9D9D9D)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          HomeBookmarkLocationSubview(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
