import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeController', () {
    late HomeController controller;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      registerFakeLocationServices();
      registerHomeInfrastructureServices();
      controller = createTestHomeController();
    });

    tearDown(() {
      controller.disableDriverNearbyTimer();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.indexNavigationBar.value, 0);
      expect(controller.indexBanner.value, 0.0);
      expect(controller.activeOrderList, isEmpty);
      expect(controller.isActiveOrderListNotEmpty.value, false);
      expect(controller.isFetch.value, false);
      expect(controller.isCriticalError.value, false);
      expect(controller.totalUnreadMessageCount.value, 0);
      expect(controller.activeOrderStatus.value, '-');
    });

    test('isSameDay returns true for same calendar day', () {
      final date = DateTime(2026, 6, 12, 8, 30);
      expect(controller.isSameDay(date, DateTime(2026, 6, 12, 22, 0)), isTrue);
    });

    test('isSameDay returns false for different calendar days', () {
      final date = DateTime(2026, 6, 12);
      expect(controller.isSameDay(date, DateTime(2026, 6, 13)), isFalse);
    });

    test('isBookmarkHomeIsSet returns false when no home bookmark exists', () {
      expect(controller.isBookmarkHomeIsSet(), isFalse);
    });

    test('isBookmarkCompanyIsSet returns false when no company bookmark exists', () {
      expect(controller.isBookmarkCompanyIsSet(), isFalse);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
