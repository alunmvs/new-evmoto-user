import 'package:get/get.dart';

class PhotoViewerController extends GetxController {
  final photoAttachmentUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    photoAttachmentUrl.value = Get.arguments?['photo_attachment_url'] ?? "";
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
