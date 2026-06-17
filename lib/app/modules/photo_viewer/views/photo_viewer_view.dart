import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/photo_viewer_controller.dart';

class PhotoViewerView extends GetView<PhotoViewerController> {
  const PhotoViewerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(
              controller.photoAttachmentUrl.value,
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 3.0,
            strictScale: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey0
                        .value,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/icon_back.svg',
                        width: 18,
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
