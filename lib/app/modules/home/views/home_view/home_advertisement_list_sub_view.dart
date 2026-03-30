import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAdvertisementListSubView extends GetView<HomeController> {
  const HomeAdvertisementListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          if (controller.isFetchAdvertisementList.value == true) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: AspectRatio(
                  aspectRatio: 311 / 155,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (controller.isFetchAdvertisementList.value == false) ...[
            Visibility(
              visible: controller.advertisementList.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: [
                      for (var advertisement
                          in controller.advertisementList) ...[
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: advertisement.isJump == 0
                                ? null
                                : () async {
                                    final Uri url = Uri.parse(
                                      advertisement.jumpUrl!,
                                    );
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: advertisement.imgUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        controller.indexBanner.value = index.toDouble();
                      },
                      height: 155,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      disableCenter: true,
                      viewportFraction: 0.85,
                      aspectRatio: 311 / 155,
                      padEnds: false,
                      autoPlayAnimationDuration: Duration(seconds: 3),
                      pauseAutoPlayOnTouch: true,
                    ),
                  ),
                  if (controller.advertisementList.length > 1) ...[
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DotsIndicator(
                        dotsCount: controller.advertisementList.length,
                        position: controller.indexBanner.value,
                        decorator: DotsDecorator(
                          spacing: EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 4,
                          ),
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey300
                              .value,
                          activeColor:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
