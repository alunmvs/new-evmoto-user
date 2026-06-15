import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_detail/controllers/sendbird_chat_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_detail/views/sendbird_chat_detail_view.dart';
import '../../../../helpers/test_dependencies.dart';

class TestSendbirdChatDetailController extends SendbirdChatDetailController {
  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SendbirdChatDetailView', () {
    late SendbirdChatDetailController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          noMessageYetStartConverstation: 'Start the conversation',
          tripHasEnded: 'This trip has ended',
          typeMessage: 'Type a message',
        ),
      );
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = TestSendbirdChatDetailController();
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.isTripHasEnded.value = true;
      controller.driverName.value = 'Rudi Driver';
      Get.put<SendbirdChatDetailController>(controller);
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    testWidgets('renders sendbird chat detail scaffold and key text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: SendbirdChatDetailView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Rudi Driver'), findsOneWidget);
      expect(find.text('Start the conversation'), findsOneWidget);
      expect(find.text('This trip has ended'), findsOneWidget);
    });
  });
}
