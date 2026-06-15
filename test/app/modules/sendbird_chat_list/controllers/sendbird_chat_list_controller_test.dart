import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_list/controllers/sendbird_chat_list_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SendbirdChatListController', () {
    late SendbirdChatListController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = SendbirdChatListController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.groupChannelList, isEmpty);
      expect(controller.unreadMessageCountGroupChannel, isEmpty);
      expect(controller.isFetch.value, false);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
