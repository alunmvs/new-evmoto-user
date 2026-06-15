import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/ride_chat_sendbird/controllers/ride_chat_sendbird_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_chat_sendbird/views/ride_chat_sendbird_view.dart';
import '../../../../helpers/test_dependencies.dart';

class TestRideChatSendbirdController extends RideChatSendbirdController {
  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideChatSendbirdView', () {
    late RideChatSendbirdController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          tripHasEnded: 'This trip has ended',
          typeMessage: 'Type a message',
        ),
      );
      registerTestUserServices();
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = TestRideChatSendbirdController();
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.isTripHasEnded.value = true;
      controller.driverName.value = 'Eko Driver';
      controller.driverLicensePlate.value = 'B 5678 EF';
      controller.driverAvatarUrl.value = 'https://example.com/driver.png';
      Get.put<RideChatSendbirdController>(controller);
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    testWidgets('renders ride chat scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: RideChatSendbirdView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Eko Driver'), findsOneWidget);
      expect(find.text('B 5678 EF'), findsOneWidget);
      expect(find.text('This trip has ended'), findsOneWidget);
    });
  });
}
