import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockOpenMapsRepository extends Mock implements OpenMapsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ActivityDetailController', () {
    late ActivityDetailController controller;
    late MockOrderRideRepository orderRideRepository;
    late MockOpenMapsRepository openMapsRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestHomeController();
      orderRideRepository = MockOrderRideRepository();
      openMapsRepository = MockOpenMapsRepository();
      controller = ActivityDetailController(
        orderRideRepository: orderRideRepository,
        openMapsRepository: openMapsRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.orderId.value, '');
      expect(controller.orderType.value, 0);
      expect(controller.rating.value, 0.0);
      expect(controller.isFetch.value, false);
      expect(controller.isCriticalError.value, false);
      expect(controller.markers, isEmpty);
    });

    testWidgets('should parse order_id and order_type from Get.arguments', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'order_id': 'ORD-55', 'order_type': 2};

      await tester.pumpWidget(const SizedBox.shrink());
      controller.orderId.value = Get.arguments['order_id'] ?? '';
      controller.orderType.value = Get.arguments['order_type'] ?? 1;
      await tester.pump();

      expect(controller.orderId.value, 'ORD-55');
      expect(controller.orderType.value, 2);
    });

    test('getTravelFare sums ride fare components', () {
      controller.orderRideDetail.value = OrderRide(
        startMoney: 10000,
        mileageMoney: 5000,
        durationMoney: 3000,
        longDistanceMoney: 2000,
        nightMoney: 1000,
        fastigiumMoney: 500,
      );

      expect(controller.getTravelFare(), 21500);
    });

    test('getPromoMoney returns coupon money when available', () {
      controller.orderRideDetail.value = OrderRide(couponMoney: 7500);

      expect(controller.getPromoMoney(), 7500);
    });

    test('getPromoMoney falls back to discount money', () {
      controller.orderRideDetail.value = OrderRide(discountMoney: 2500);

      expect(controller.getPromoMoney(), 2500);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
