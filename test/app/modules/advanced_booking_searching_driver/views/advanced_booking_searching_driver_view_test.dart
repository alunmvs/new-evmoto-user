import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_searching_driver/controllers/advanced_booking_searching_driver_controller.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_searching_driver/views/advanced_booking_searching_driver_view.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class TestAdvancedBookingSearchingDriverController
    extends AdvancedBookingSearchingDriverController {
  TestAdvancedBookingSearchingDriverController({
    required super.advanceBookingRepository,
    required super.driverNearbyRepository,
  });

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdvancedBookingSearchingDriverView', () {
    late AdvancedBookingSearchingDriverController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          nearestDriverNotAvailable: 'No drivers nearby',
          evMotorcycleDriverSearch: 'Searching for EVMoto driver',
        ),
      );
      controller = TestAdvancedBookingSearchingDriverController(
        advanceBookingRepository: MockAdvanceBookingRepository(),
        driverNearbyRepository: MockDriverNearbyRepository(),
      );
      controller.isFetch.value = false;
      controller.driverNearbyList.clear();
      controller.advancedBooking.value = AdvancedBooking(
        startAddress: 'Pickup at Sudirman',
        endAddress: 'Drop at Thamrin',
      );
      Get.put<AdvancedBookingSearchingDriverController>(controller);
    });

    tearDown(() {
      controller.disableDriverNearbyTimer();
      Get.reset();
    });

    testWidgets('renders searching driver scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AdvancedBookingSearchingDriverView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Pickup at Sudirman'), findsOneWidget);
      expect(find.text('Drop at Thamrin'), findsOneWidget);
      expect(find.text('Searching for EVMoto driver'), findsOneWidget);
    });
  });
}
