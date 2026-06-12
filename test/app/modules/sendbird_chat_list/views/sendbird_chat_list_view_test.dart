import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_list/controllers/sendbird_chat_list_controller.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_list/views/sendbird_chat_list_view.dart';
import '../../../../helpers/test_dependencies.dart';

class TestSendbirdChatListController extends SendbirdChatListController {
  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SendbirdChatListView', () {
    late SendbirdChatListController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          message: 'Messages',
          noMessageYet: 'No messages yet',
          conversationWillAppear: 'Conversations will appear here',
        ),
      );
      registerTestHomeController();
      registerSendbirdTestServices();
      controller = TestSendbirdChatListController();
      controller.isFetch.value = false;
      controller.groupChannelList.clear();
      Get.put<SendbirdChatListController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders sendbird chat list scaffold and empty state text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: SendbirdChatListView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('No messages yet'), findsOneWidget);
      expect(find.text('Conversations will appear here'), findsOneWidget);
    });
  });
}
