import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_introduction_controller.dart';

class OnboardingIntroductionView
    extends GetView<OnboardingIntroductionController> {
  const OnboardingIntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        child: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 56),
                      if (controller.pageNumber.value == 0) ...[
                        SvgPicture.asset(
                          "assets/images/img_onboarding_1.svg",
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            border: Border.all(color: Color(0XFFE5E5E5)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Perjalanan, Pengiriman, dan Kuliner dalam Genggaman",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .headingSmallBold
                                    .value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Pesan EV Moto untuk perjalanan, nikmati makanan favorit, dan kirim paket dengan mudah, semuanya dalam satu aplikasi!",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .bodyLargeRegular
                                    .value,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (controller.pageNumber.value == 1) ...[
                        SvgPicture.asset(
                          "assets/images/img_onboarding_2.svg",
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            border: Border.all(color: Color(0XFFE5E5E5)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Melaju Tanpa Polusi, Berkendara Lebih Asri",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .headingSmallBold
                                    .value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Perjalanan ramah lingkungan dengan EV Moto. Tanpa asap, tanpa bising, hanya perjalanan nyaman dan bebas polusi!",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .bodyLargeRegular
                                    .value,
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 36),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    controller.pageNumber.value == 0
                                    ? controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value
                                    : controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                              ),
                              SizedBox(width: 6),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    controller.pageNumber.value == 1
                                    ? controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value
                                    : controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.onTapNext();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              "Lanjutkan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
