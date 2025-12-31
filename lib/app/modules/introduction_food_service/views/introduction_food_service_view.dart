import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/introduction_food_service_controller.dart';

class IntroductionFoodServiceView
    extends GetView<IntroductionFoodServiceController> {
  const IntroductionFoodServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              "assets/icons/icon_close.svg",
              width: 24,
              height: 24,
            ),
          ),
          title: Text(
            controller.languageServices.language.value.foodDelivery ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
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
                  SizedBox(height: 64),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.5),
                    child: SvgPicture.asset(
                      "assets/images/img_intro_food_service.svg",
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(height: 32),
                  Stack(
                    children: [
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
                                      .introFoodDeliveryTitle ??
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
                                      .introFoodDeliveryDescription ??
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
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .sematicColorYellow300
                                .value,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .comingSoon ??
                                "-",
                            style: controller
                                .typographyServices
                                .captionLargeBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorYellow100
                                      .value,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.themeColorServices.primaryBlue.value,
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
                                  .introFoodDeliveryButton ??
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
    );
  }
}
