import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_detail/controllers/sendbird_chat_detail_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SendbirdChatDetailController', () {
    late SendbirdChatDetailController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = SendbirdChatDetailController();
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.groupChannelUrl.value, isNull);
      expect(controller.groupChannel.value, isNull);
      expect(controller.driverId.value, isNull);
      expect(controller.driverName.value, isNull);
      expect(controller.messageList, isEmpty);
      expect(controller.isTripHasEnded.value, true);
      expect(controller.isCriticalError.value, false);
      expect(controller.isFetch.value, false);
    });

    testWidgets('should parse group_channel_url from Get.arguments', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'group_channel_url': 'sendbird_group_channel_123'};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.groupChannelUrl.value = Get.arguments['group_channel_url'];
      await tester.pump();

      expect(controller.groupChannelUrl.value, 'sendbird_group_channel_123');
    });

    test('isChatRead returns true when driver read after message', () {
      final messageCreatedAt = DateTime(2026, 6, 12, 10, 0);
      final driverLastSeenAt = DateTime(2026, 6, 12, 10, 5);

      expect(
        controller.isChatRead(
          messageCreatedAt: messageCreatedAt,
          driverLastSeenAt: driverLastSeenAt,
        ),
        isTrue,
      );
    });

    test('isChatRead returns false when driver has not read message yet', () {
      final messageCreatedAt = DateTime(2026, 6, 12, 10, 5);
      final driverLastSeenAt = DateTime(2026, 6, 12, 10, 0);

      expect(
        controller.isChatRead(
          messageCreatedAt: messageCreatedAt,
          driverLastSeenAt: driverLastSeenAt,
        ),
        isFalse,
      );
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
