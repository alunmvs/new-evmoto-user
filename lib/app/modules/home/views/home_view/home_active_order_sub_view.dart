import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';

class HomeActiveOrderSubView extends GetView<HomeController> {
  const HomeActiveOrderSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Visibility(
          visible: controller.activeOrderStatus.value != '-',
          child: GestureDetector(
            onTap: () async {
              await controller.onTapRideService(isFillCurrentLocation: false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0XFFF8FBFE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.themeColorServices.overlayDark200.value
                          .withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(9.23),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_ride.svg",
                                width: 23.38,
                                height: 17.31,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            controller.activeOrderStatus.value,
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
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/icon_arrow_right.svg",
                              width: 13 * 1.3,
                              height: 7.5 * 1.3,
                              colorFilter: ColorFilter.mode(
                                controller.themeColorServices.primaryBlue.value,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
