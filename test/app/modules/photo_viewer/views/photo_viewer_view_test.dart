import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/photo_viewer/controllers/photo_viewer_controller.dart';
import 'package:new_evmoto_user/app/modules/photo_viewer/views/photo_viewer_view.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PhotoViewerView', () {
    late PhotoViewerController controller;

    setUp(() {
      controller = PhotoViewerController();
      Get.put<PhotoViewerController>(controller);
      controller.photoAttachmentUrl.value = 'https://example.com/photo.jpg';
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders PhotoView with scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: PhotoViewerView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PhotoView), findsOneWidget);
    });
  });
}
