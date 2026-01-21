import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/introduction_delivery_service_controller.dart';

class IntroductionDeliveryServiceView
    extends GetView<IntroductionDeliveryServiceController> {
  const IntroductionDeliveryServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.deliveryService ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 64),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.5),
                    child: SvgPicture.asset(
                      "assets/images/img_intro_delivery_service.svg",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
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
                                .introRideTitle ??
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
                                .introRideDescription ??
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
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LoaderElevatedButton(
                    onPressed: () async {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                        'is_introduction_delivery_service_shown',
                        true,
                      );

                      Get.back();
                      await controller.homeController.onTapRideService();
                    },
                    borderSide: BorderSide(
                      color: controller
                          .themeColorServices
                          .sematicColorBlue200
                          .value,
                      width: 2,
                    ),
                    child: Text(
                      controller
                              .languageServices
                              .language
                              .value
                              .introRideButton ??
                          "-",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
