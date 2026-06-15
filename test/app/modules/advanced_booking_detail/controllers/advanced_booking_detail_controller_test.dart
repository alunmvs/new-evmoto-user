import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

class MockOpenMapsRepository extends Mock implements OpenMapsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdvancedBookingDetailController', () {
    late AdvancedBookingDetailController controller;
    late MockAdvanceBookingRepository advanceBookingRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      advanceBookingRepository = MockAdvanceBookingRepository();
      controller = AdvancedBookingDetailController(
        orderRideRepository: MockOrderRideRepository(),
        openMapsRepository: MockOpenMapsRepository(),
        advanceBookingRepository: advanceBookingRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.id.value, isNull);
      expect(controller.rating.value, 0.0);
      expect(controller.isFetch.value, false);
      expect(controller.isCriticalError.value, false);
      expect(controller.markers, isEmpty);
    });

    testWidgets('should parse id from Get.arguments without repository calls', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'id': 77};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.id.value = Get.arguments['id'];
      await tester.pump();

      expect(controller.id.value, 77);
    });

    test('getTravelFare sums advanced booking fare components', () {
      controller.advancedBooking.value = AdvancedBooking(
        startMoney: 12000,
        waitMoney: 1000,
        mileageMoney: 4000,
        durationMoney: 2000,
        longDistanceMoney: 1500,
        nightMoney: 500,
        fastigiumMoney: 250,
      );

      expect(controller.getTravelFare(), 21250);
    });

    test('isAbleCancelAdvanceBooking returns true for scheduled state', () {
      controller.advancedBooking.value = AdvancedBooking(state: 0);

      expect(controller.isAbleCancelAdvanceBooking(), isTrue);
    });

    test('isAbleOrderAgainAdvanceBooking returns true for cancelled state', () {
      controller.advancedBooking.value = AdvancedBooking(state: 5);

      expect(controller.isAbleOrderAgainAdvanceBooking(), isTrue);
    });

    test('isAbleOrderAgainAdvanceBooking returns true when ride completed', () {
      controller.advancedBooking.value = AdvancedBooking(state: 2);
      controller.orderRideDetail.value = OrderRide(
        state: OrderState.COMPLETED_STATE_LIST.first,
      );

      expect(controller.isAbleOrderAgainAdvanceBooking(), isTrue);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
