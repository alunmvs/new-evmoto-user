import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/chat_list/controllers/chat_list_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatListController', () {
    late ChatListController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      controller = ChatListController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.roomList, isEmpty);
      expect(controller.isSeeMoreRoomList.value, true);
      expect(controller.isFetch.value, false);
      expect(controller.lastDoc, isNull);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
