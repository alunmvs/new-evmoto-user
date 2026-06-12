import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_chat_sendbird/controllers/ride_chat_sendbird_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideChatSendbirdController', () {
    late RideChatSendbirdController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = RideChatSendbirdController();
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.driverId.value, isNull);
      expect(controller.driverName.value, isNull);
      expect(controller.orderId.value, isNull);
      expect(controller.messageList, isEmpty);
      expect(controller.isTripHasEnded.value, true);
      expect(controller.isCriticalError.value, false);
      expect(controller.isFetch.value, false);
    });

    testWidgets('should parse ride chat arguments without Sendbird calls', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {
        'driver_id': 42,
        'driver_name': 'Budi',
        'driver_avatar_url': 'https://example.com/avatar.png',
        'driver_license_plate': 'B 1234 CD',
        'order_id': 1001,
        'order_type': 1,
        'state': 2,
      };

      await tester.pumpWidget(const SizedBox.shrink());
      controller.driverId.value = Get.arguments['driver_id'];
      controller.driverName.value = Get.arguments['driver_name'];
      controller.driverAvatarUrl.value = Get.arguments['driver_avatar_url'];
      controller.driverLicensePlate.value = Get.arguments['driver_license_plate'];
      controller.orderId.value = Get.arguments['order_id'];
      controller.orderType.value = Get.arguments['order_type'];
      controller.state.value = Get.arguments['state'];
      await tester.pump();

      expect(controller.driverId.value, 42);
      expect(controller.driverName.value, 'Budi');
      expect(controller.driverAvatarUrl.value, 'https://example.com/avatar.png');
      expect(controller.driverLicensePlate.value, 'B 1234 CD');
      expect(controller.orderId.value, 1001);
      expect(controller.orderType.value, 1);
      expect(controller.state.value, 2);
    });

    test('isChatRead returns true when driver read after message', () {
      expect(
        controller.isChatRead(
          messageCreatedAt: DateTime(2026, 6, 12, 9, 0),
          driverLastSeenAt: DateTime(2026, 6, 12, 9, 10),
        ),
        isTrue,
      );
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
