import 'package:get/get.dart';

import '../controllers/sendbird_chat_detail_controller.dart';

class SendbirdChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendbirdChatDetailController>(
      () => SendbirdChatDetailController(),
    );
  }
}
