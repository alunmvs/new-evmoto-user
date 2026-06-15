import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class TestAdvancedBookingDetailController
    extends AdvancedBookingDetailController {
  TestAdvancedBookingDetailController({
    required super.orderRideRepository,
    required super.openMapsRepository,
    required super.advanceBookingRepository,
  });

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdvancedBookingDetailView', () {
    late AdvancedBookingDetailController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          advancedBookingStatusDescriptionScheduled:
              'Your booking is scheduled',
          cancel: 'Cancel',
        ),
      );
      registerTestHomeController();
      controller = TestAdvancedBookingDetailController(
        orderRideRepository: MockOrderRideRepository(),
        openMapsRepository: MockOpenMapsRepository(),
        advanceBookingRepository: MockAdvanceBookingRepository(),
      );
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.advancedBooking.value = AdvancedBooking(
        id: 10,
        state: 0,
        travelTime: '2026-06-15 08:00:00',
        startAddress: 'Jl. Sudirman',
        endAddress: 'Jl. Thamrin',
        orderMoney: 0,
        waitMoney: 0,
      );
      controller.orderRideDetail.value = OrderRide(orderNum: 'ADV-001');
      Get.put<AdvancedBookingDetailController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders advanced booking detail scaffold and key text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AdvancedBookingDetailView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Detail Jadwal Pemesanan'), findsOneWidget);
      expect(find.text('Your booking is scheduled'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
