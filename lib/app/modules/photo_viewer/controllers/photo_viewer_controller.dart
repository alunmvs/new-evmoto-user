import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';

class PhotoViewerController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();

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
