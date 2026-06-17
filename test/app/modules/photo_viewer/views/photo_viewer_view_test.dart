import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/photo_viewer/controllers/photo_viewer_controller.dart';
import 'package:new_evmoto_user/app/modules/photo_viewer/views/photo_viewer_view.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PhotoViewerView', () {
    late PhotoViewerController controller;

    setUp(() {
      registerCoreTestServices();
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
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('back button pops the current route', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/previous',
          getPages: [
            GetPage(
              name: '/previous',
              page: () => const Scaffold(body: Text('previous')),
            ),
            GetPage(
              name: '/viewer',
              page: () => const PhotoViewerView(),
              binding: BindingsBuilder(() {
                Get.put(PhotoViewerController());
              }),
            ),
          ],
        ),
      );
      Get.toNamed('/viewer');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PhotoViewerView), findsOneWidget);

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(PhotoViewerView), findsNothing);
      expect(find.text('previous'), findsOneWidget);
    });
  });
}
