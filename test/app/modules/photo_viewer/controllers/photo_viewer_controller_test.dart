import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/photo_viewer/controllers/photo_viewer_controller.dart';

import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PhotoViewerController', () {
    late PhotoViewerController controller;

    setUp(() {
      registerCoreTestServices();
      controller = PhotoViewerController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have empty photoAttachmentUrl as initial state', () {
      expect(controller.photoAttachmentUrl.value, '');
    });

    testWidgets('should set photoAttachmentUrl from Get.arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'photo_attachment_url': 'https://example.com/a.jpg'};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.onInit();
      await tester.pump();

      expect(controller.photoAttachmentUrl.value, 'https://example.com/a.jpg');
    });

    testWidgets(
      'should default photoAttachmentUrl to empty when argument is missing',
      (WidgetTester tester) async {
        Get.routing.args = {};

        await tester.pumpWidget(const SizedBox.shrink());
        controller.onInit();
        await tester.pump();

        expect(controller.photoAttachmentUrl.value, '');
      },
    );

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
