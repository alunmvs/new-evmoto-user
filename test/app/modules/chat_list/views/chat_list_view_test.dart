import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/modules/chat_list/controllers/chat_list_controller.dart';
import 'package:new_evmoto_user/app/modules/chat_list/views/chat_list_view.dart';
import '../../../../helpers/test_dependencies.dart';

class TestChatListController extends ChatListController {
  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatListView', () {
    late ChatListController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      controller = TestChatListController();
      controller.isFetch.value = false;
      controller.roomList.value = [
        EvmotoOrderChatParticipants(
          docId: 'doc-1',
          driverName: 'Budi Driver',
          orderId: 'ORD-100',
          lastMessage: 'Hello',
        ),
      ];
      Get.put<ChatListController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders chat list scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: ChatListView()));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Pesan'), findsOneWidget);
      expect(find.text('Budi Driver'), findsOneWidget);
      expect(find.text('ORD-100'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });
  });
}
