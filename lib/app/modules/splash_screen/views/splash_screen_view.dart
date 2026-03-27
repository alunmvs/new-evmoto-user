import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: GlobalBodyHandler(
          isFetch: controller.isFetch.value,
          isCriticalError: controller.isCriticalError.value,
          onInit: () async {
            await controller.onInit();
          },
          body: controller.isFetch.value
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CachedNetworkImage(
                    imageUrl: controller.splashScreenQueryImage.value.url!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
