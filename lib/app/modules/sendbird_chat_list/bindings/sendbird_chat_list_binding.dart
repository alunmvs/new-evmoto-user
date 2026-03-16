import 'package:get/get.dart';

import '../controllers/sendbird_chat_list_controller.dart';

class SendbirdChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendbirdChatListController>(
      () => SendbirdChatListController(),
    );
  }
}
