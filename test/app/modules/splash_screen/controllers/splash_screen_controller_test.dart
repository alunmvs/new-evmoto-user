import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/query_image_model.dart';
import 'package:new_evmoto_user/app/modules/splash_screen/controllers/splash_screen_controller.dart';
import 'package:new_evmoto_user/app/repositories/query_image_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockQueryImageRepository extends Mock implements QueryImageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreenController', () {
    late SplashScreenController controller;
    late MockQueryImageRepository queryImageRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      registerFakeLocationServices();
      queryImageRepository = MockQueryImageRepository();
      controller = SplashScreenController(
        queryImageRepository: queryImageRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state without calling onInit', () {
      expect(controller.splashScreenQueryImage.value.url, isNull);
      expect(controller.isCriticalError.value, false);
      expect(controller.isFetch.value, false);
    });

    test('should load splash screen image from repository', () async {
      final images = [
        QueryImage(
          id: 1,
          url: 'https://example.com/splash.png',
        ),
      ];

      when(
        () => queryImageRepository.getQueryImageList(type: 1, usePort: 1),
      ).thenAnswer((_) async => images);

      await controller.getSplashScreenQueryImage();

      expect(
        controller.splashScreenQueryImage.value.url,
        'https://example.com/splash.png',
      );
      verify(
        () => queryImageRepository.getQueryImageList(type: 1, usePort: 1),
      ).called(2);
    });

    test('should leave splash image empty when repository returns no images', () async {
      when(
        () => queryImageRepository.getQueryImageList(type: 1, usePort: 1),
      ).thenAnswer((_) async => []);

      await controller.getSplashScreenQueryImage();

      expect(controller.splashScreenQueryImage.value.url, isNull);
      verify(
        () => queryImageRepository.getQueryImageList(type: 1, usePort: 1),
      ).called(1);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
