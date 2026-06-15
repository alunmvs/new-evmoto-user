import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/controllers/ride_order_cancel_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockOrderRideRepository extends Mock implements OrderRideRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideOrderCancelController', () {
    late RideOrderCancelController controller;
    late MockOrderRideRepository orderRideRepository;

    setUp(() {
      registerCoreTestServices();
      orderRideRepository = MockOrderRideRepository();
      controller = RideOrderCancelController(
        orderRideRepository: orderRideRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have empty initial state before onInit', () {
      expect(controller.orderId.value, '');
      expect(controller.orderType.value, 0);
      expect(controller.reason.value, '');
      expect(controller.isFetch.value, false);
      expect(controller.formGroup.valid, false);
    });

    testWidgets('should set orderId and orderType from Get.arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'order_id': 'ORD-123', 'order_type': 1};

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.orderId.value, 'ORD-123');
      expect(controller.orderType.value, 1);
      expect(controller.isFetch.value, false);
    });

    test('should mark form invalid when reason is empty', () {
      controller.formGroup.control('reason').value = '';
      controller.formGroup.markAllAsTouched();

      expect(controller.formGroup.valid, false);
    });

    test('should mark form valid when reason is provided', () {
      controller.formGroup.control('reason').value = 'Driver too far';
      controller.formGroup.markAllAsTouched();

      expect(controller.formGroup.valid, true);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
