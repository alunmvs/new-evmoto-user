import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/query_image_model.dart';
import 'package:new_evmoto_user/app/modules/splash_screen/controllers/splash_screen_controller.dart';
import 'package:new_evmoto_user/app/modules/splash_screen/views/splash_screen_view.dart';
import 'package:new_evmoto_user/app/repositories/query_image_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockQueryImageRepository extends Mock implements QueryImageRepository {}

class TestSplashScreenController extends SplashScreenController {
  TestSplashScreenController({required super.queryImageRepository});

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreenView', () {
    late TestSplashScreenController controller;
    late MockQueryImageRepository queryImageRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      registerFakeLocationServices();
      queryImageRepository = MockQueryImageRepository();
      controller = TestSplashScreenController(
        queryImageRepository: queryImageRepository,
      );
      Get.put<SplashScreenController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders loading indicator while fetching', (
      WidgetTester tester,
    ) async {
      controller.isFetch.value = true;
      controller.isCriticalError.value = false;

      await tester.pumpWidget(
        const GetMaterialApp(home: SplashScreenView()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders loading indicator when splash image url is null', (
      WidgetTester tester,
    ) async {
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.splashScreenQueryImage.value = QueryImage();

      await tester.pumpWidget(
        const GetMaterialApp(home: SplashScreenView()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
