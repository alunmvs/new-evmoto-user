import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import '../../../../helpers/fake_google_maps_flutter_platform.dart';
import '../../../../helpers/test_dependencies.dart';

class TestActivityDetailController extends ActivityDetailController {
  TestActivityDetailController({
    required super.orderRideRepository,
    required super.openMapsRepository,
  });

  @override
  Future<void> onInit() async {}
}

void main() {
  registerFakeGoogleMapsFlutterPlatform();

  group('ActivityDetailView', () {
    late ActivityDetailController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          orderAgain: 'Order Again',
          km: 'Km',
          pickup: 'Pickup',
          objective: 'Destination',
        ),
      );
      registerTestHomeController();
      controller = TestActivityDetailController(
        orderRideRepository: MockOrderRideRepository(),
        openMapsRepository: MockOpenMapsRepository(),
      );
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.orderRideDetail.value = OrderRide(
        orderNum: 'ORD-2024-001',
        insertTime: '2026-06-12 10:30:00',
        driverName: 'Budi Driver',
        licensePlate: 'B 1234 CD',
        brand: 'Toyota',
        carColor: 'White',
        state: 8,
        waitMoney: 0,
        payMoney: 0,
        additionalCharge: 0,
        startMoney: 0,
        mileageMoney: 0,
        durationMoney: 0,
      );
      Get.put<ActivityDetailController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders activity detail scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: ActivityDetailView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('ORD-2024-001'), findsOneWidget);
      expect(find.text('Budi Driver'), findsOneWidget);
      expect(find.text('Order Again'), findsOneWidget);
    });
  });
}
