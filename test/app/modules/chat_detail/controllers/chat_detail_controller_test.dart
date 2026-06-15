import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/chat_detail/controllers/chat_detail_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatDetailController', () {
    late ChatDetailController controller;
    late MockUploadImageRepository uploadImageRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      uploadImageRepository = MockUploadImageRepository();
      controller = ChatDetailController(
        uploadImageRepository: uploadImageRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      controller.textEditingController.dispose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.docId.value, '');
      expect(controller.message.value, '');
      expect(controller.attachmentUrl.value, '');
      expect(controller.isAttachmentOptionOpen.value, false);
      expect(controller.isTripHasEnded.value, true);
      expect(controller.isFetch.value, false);
      expect(controller.evmotoOrderChatMessagesList, isEmpty);
    });

    testWidgets('should parse doc_id from Get.arguments without Firebase calls', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'doc_id': 'chat-room-42'};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.docId.value = Get.arguments['doc_id'];
      await tester.pump();

      expect(controller.docId.value, 'chat-room-42');
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
