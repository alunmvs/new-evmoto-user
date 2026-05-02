import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatDetailController>(
      () =>
          ChatDetailController(uploadImageRepository: UploadImageRepository()),
    );
  }
}
