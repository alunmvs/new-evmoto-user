import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideOrderDetailController', () {
    late RideOrderDetailController controller;

    setUp(() {
      registerTestRideOrderDetailServices();
      controller = createTestRideOrderDetailController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.orderId.value, '');
      expect(controller.orderType.value, 0);
      expect(controller.state.value, 0);
      expect(controller.isFetch.value, false);
      expect(controller.isGoogleMapControllerCreated.value, false);
      expect(controller.totalUnreadMessageCount.value, 0);
      expect(controller.orderRideDetail.value, isA<OrderRide>());
    });

    testWidgets('should parse order_id and order_type from Get.arguments', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'order_id': 'ORD-99', 'order_type': 2};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.orderId.value = Get.arguments['order_id'] ?? '';
      controller.orderType.value = Get.arguments['order_type'] ?? 0;
      await tester.pump();

      expect(controller.orderId.value, 'ORD-99');
      expect(controller.orderType.value, 2);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
