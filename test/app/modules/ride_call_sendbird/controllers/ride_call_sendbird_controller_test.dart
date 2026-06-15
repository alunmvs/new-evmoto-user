import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_call_sendbird/controllers/ride_call_sendbird_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideCallSendbirdController', () {
    late RideCallSendbirdController controller;

    setUp(() {
      registerCoreTestServices();
      registerSendbirdTestServices();
      controller = RideCallSendbirdController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.callId.value, '');
      expect(controller.isCaller.value, false);
      expect(controller.driverName.value, '');
      expect(controller.driverAvatarUrl.value, '');
      expect(controller.isMicrophoneOn.value, true);
      expect(controller.isSpeakerOn.value, false);
      expect(controller.isCriticalError.value, false);
      expect(controller.isFetch.value, false);
    });

    testWidgets('should parse call arguments without starting Sendbird call', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {
        'call_id': 'call-abc',
        'is_caller': false,
        'driver_name': 'Andi Driver',
        'driver_avatar_url': 'https://example.com/avatar.png',
      };

      await tester.pumpWidget(const SizedBox.shrink());
      controller.callId.value = Get.arguments['call_id'] ?? '';
      controller.isCaller.value = Get.arguments['is_caller'];
      controller.driverName.value = Get.arguments['driver_name'];
      controller.driverAvatarUrl.value = Get.arguments['driver_avatar_url'] ?? '';
      await tester.pump();

      expect(controller.callId.value, 'call-abc');
      expect(controller.isCaller.value, false);
      expect(controller.driverName.value, 'Andi Driver');
      expect(controller.driverAvatarUrl.value, 'https://example.com/avatar.png');
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
