import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/photo_viewer_controller.dart';

class PhotoViewerView extends GetView<PhotoViewerController> {
  const PhotoViewerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          controller.photoAttachmentUrl.value,
        ),
      ),
    );
  }
}
