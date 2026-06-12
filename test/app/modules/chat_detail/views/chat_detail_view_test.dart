import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_messages_model.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/chat_detail/controllers/chat_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/chat_detail/views/chat_detail_view.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class TestChatDetailController extends ChatDetailController {
  TestChatDetailController({required super.uploadImageRepository});

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatDetailView', () {
    late ChatDetailController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          noMessagesYet: 'No messages yet',
          tripHasEnded: 'This trip has ended',
          typeMessage: 'Type a message',
        ),
      );
      registerTestHomeController();
      controller = TestChatDetailController(
        uploadImageRepository: MockUploadImageRepository(),
      );
      controller.isFetch.value = false;
      controller.isTripHasEnded.value = true;
      controller.evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants(
        driverName: 'Andi Driver',
      );
      Get.put<ChatDetailController>(controller);
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    testWidgets('renders chat detail scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: ChatDetailView()));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Andi Driver'), findsOneWidget);
      expect(find.text('No messages yet'), findsOneWidget);
      expect(find.text('This trip has ended'), findsOneWidget);
    });

    testWidgets('renders user message when messages are present', (
      WidgetTester tester,
    ) async {
      controller.isTripHasEnded.value = false;
      controller.evmotoOrderChatMessagesList.value = [
        EvmotoOrderChatMessages(
          senderType: 'user',
          senderMessage: 'On my way',
        ),
      ];

      await tester.pumpWidget(const GetMaterialApp(home: ChatDetailView()));
      await tester.pump();

      expect(find.text('On my way'), findsOneWidget);
      expect(find.text('Type a message'), findsOneWidget);
    });
  });
}
