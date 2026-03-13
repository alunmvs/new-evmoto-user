import 'package:get/get.dart';

import '../controllers/ride_chat_sendbird_controller.dart';

class RideChatSendbirdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideChatSendbirdController>(
      () => RideChatSendbirdController(),
    );
  }
}
