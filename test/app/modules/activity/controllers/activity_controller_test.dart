import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ActivityController', () {
    late ActivityController controller;
    late MockOrderRideRepository orderRideRepository;
    late MockAdvanceBookingRepository advancedBookingRepository;

    setUp(() {
      registerCoreTestServices();
      orderRideRepository = MockOrderRideRepository();
      advancedBookingRepository = MockAdvanceBookingRepository();

      registerMinimalHomeController(orderRideRepository: orderRideRepository);

      when(
        () => orderRideRepository.getHistoryOrderList(
          language: any(named: 'language'),
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);

      when(
        () => advancedBookingRepository.getAdvancedBookingList(
          pageNo: any(named: 'pageNo'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async => []);

      controller = ActivityController(
        orderRideRepository: orderRideRepository,
        advancedBookingRepository: advancedBookingRepository,
      );
    });

    tearDown(() {
      try {
        controller.tabController.dispose();
      } catch (_) {}
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.indexTabBar.value, 0);
      expect(controller.historyOrderList, isEmpty);
      expect(controller.advancedBookingList, isEmpty);
      expect(controller.isFetch.value, false);
      expect(controller.isCriticalError.value, false);
      expect(controller.historyOrderSelectedOrderType.value, 1);
    });

    testWidgets('should load history and advanced booking on onInit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isFetch.value, false);
      expect(controller.historyOrderList, isEmpty);
      expect(controller.advancedBookingList, isEmpty);
      expect(controller.indexTabBar.value, 0);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
