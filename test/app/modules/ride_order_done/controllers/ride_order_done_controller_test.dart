import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/controllers/ride_order_done_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideOrderDoneController', () {
    late RideOrderDoneController controller;
    late MockOrderRideRepository orderRideRepository;

    setUp(() {
      registerCoreTestServices();
      registerMinimalHomeController();

      orderRideRepository = MockOrderRideRepository();
      controller = TestRideOrderDoneController(
        orderRideRepository: orderRideRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.orderId.value, '');
      expect(controller.orderType.value, 0);
      expect(controller.rating.value, 5.0);
      expect(controller.showIHavePaidButton.value, false);
      expect(controller.isFetch.value, false);
    });

    test('getTravelFare should sum ride fare components', () {
      controller.orderRideDetail.value = OrderRide(
        startMoney: 10000,
        waitMoney: 2000,
        mileageMoney: 3000,
        durationMoney: 4000,
        longDistanceMoney: 5000,
        nightMoney: 1000,
        fastigiumMoney: 500,
      );

      expect(controller.getTravelFare(), 25500);
    });

    test('getPromoMoney should return coupon money when available', () {
      controller.orderRideDetail.value = OrderRide(
        couponMoney: 15000,
        discountMoney: 5000,
      );

      expect(controller.getPromoMoney(), 15000);
    });

    test('getPromoMoney should return discount money when coupon is empty', () {
      controller.orderRideDetail.value = OrderRide(
        couponMoney: 0,
        discountMoney: 5000,
      );

      expect(controller.getPromoMoney(), 5000);
    });

    test('checkShowIHavePaidButton should enable button after 5 minutes', () {
      controller.waitingDriverConfirmStartAt.value = DateTime.now().subtract(
        const Duration(minutes: 6),
      );

      controller.checkShowIHavePaidButton();

      expect(controller.showIHavePaidButton.value, true);
    });

    testWidgets('should set orderId and orderType from arguments on onInit', (
      WidgetTester tester,
    ) async {
      when(
        () => orderRideRepository.getOrderRideDetailbyOrderId(
          orderId: any(named: 'orderId'),
          orderType: any(named: 'orderType'),
        ),
      ).thenAnswer((_) async => OrderRide(state: 7));

      when(
        () => orderRideRepository.getOrderRideServerDetail(
          language: any(named: 'language'),
          orderId: any(named: 'orderId'),
          orderType: any(named: 'orderType'),
        ),
      ).thenAnswer((_) async => OrderRideServer());

      final onInitController = RideOrderDoneController(
        orderRideRepository: orderRideRepository,
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      Get.routing.args = {'order_id': 'ORD-99', 'order_type': 2};
      await onInitController.onInit();
      await tester.pump();

      expect(onInitController.orderId.value, 'ORD-99');
      expect(onInitController.orderType.value, 2);
      expect(onInitController.isFetch.value, false);

      onInitController.onClose();
      await tester.pump();
    });

    test('should clean up timer without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
