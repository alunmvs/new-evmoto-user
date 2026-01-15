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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 56),
                      if (controller.pageNumber.value == 0) ...[
                        Expanded(
                          child: SvgPicture.asset(
                            "assets/images/img_onboarding_1.svg",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
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
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .onboardingIntroTitle1 ??
                                    "-",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .headingSmallBold
                                    .value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .onboardingIntroDescription1 ??
                                    "-",
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
                        Expanded(
                          child: SvgPicture.asset(
                            "assets/images/img_onboarding_2.svg",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                          ),
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
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .onboardingIntroTitle2 ??
                                    "-",
                                textAlign: TextAlign.center,
                                style: controller
                                    .typographyServices
                                    .headingSmallBold
                                    .value,
                              ),
                              SizedBox(height: 16),
                              Text(
                                controller
                                        .languageServices
                                        .language
                                        .value
                                        .onboardingIntroDescription2 ??
                                    "-",
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
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .buttonNext ??
                                  "-",
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
