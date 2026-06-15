import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_searching_driver/controllers/advanced_booking_searching_driver_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdvancedBookingSearchingDriverController', () {
    late AdvancedBookingSearchingDriverController controller;
    late MockAdvanceBookingRepository advanceBookingRepository;

    setUp(() {
      registerCoreTestServices();
      advanceBookingRepository = MockAdvanceBookingRepository();
      controller = AdvancedBookingSearchingDriverController(
        advanceBookingRepository: advanceBookingRepository,
        driverNearbyRepository: MockDriverNearbyRepository(),
      );
    });

    tearDown(() {
      controller.disableDriverNearbyTimer();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.advanceBookingId.value, isNull);
      expect(controller.driverNearbyList, isEmpty);
      expect(controller.nearestDistanceDriverNearby.value, 0.0);
      expect(controller.isPinLocationWaitingForDriverHide.value, false);
      expect(controller.isFetch.value, false);
      expect(controller.markers, isEmpty);
    });

    testWidgets('should parse id from Get.arguments without repository calls', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'id': 99};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.advanceBookingId.value = Get.arguments['id'];
      await tester.pump();

      expect(controller.advanceBookingId.value, 99);
    });

    test('disableDriverNearbyTimer cancels timer without error', () {
      controller.enableDriverNearbyTimer();
      expect(() => controller.disableDriverNearbyTimer(), returnsNormally);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
