import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ActivityView', () {
    late ActivityController controller;
    late MockOrderRideRepository orderRideRepository;
    late MockAdvanceBookingRepository advancedBookingRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          haveTriedEvmoto: 'Have you tried Evmoto?',
          travelComfort: 'Travel in comfort',
          orderEvMoto: 'Order Evmoto',
          advancedBookingListNotFoundTitle: 'No advanced bookings',
          advancedBookingListNotFoundDescription: 'Book a ride in advance',
          advancedBookingListNotFoundButton: 'Book Now',
        ),
      );

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

      controller = TestActivityController(
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

    testWidgets('renders activity tabs and empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: Scaffold(body: SizedBox())),
      );
      controller.tabController = TabController(length: 2, vsync: tester);
      controller.isFetch.value = false;
      Get.put<ActivityController>(controller);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(body: ActivityView()),
        ),
      );
      await tester.pump();

      expect(find.text('Reguler'), findsOneWidget);
      expect(find.text('Booking'), findsOneWidget);
      expect(find.text('Have you tried Evmoto?'), findsOneWidget);
      expect(find.text('Travel in comfort'), findsOneWidget);
      expect(find.text('Order Evmoto'), findsOneWidget);
    });
  });
}
