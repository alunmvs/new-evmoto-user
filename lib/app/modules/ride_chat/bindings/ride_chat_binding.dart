import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';

import '../controllers/ride_chat_controller.dart';

class RideChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideChatController>(
      () => RideChatController(uploadImageRepository: UploadImageRepository()),
    );
  }
}
