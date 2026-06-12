import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/controllers/voucher_list_controller.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/views/voucher_list_view.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockCouponRepository extends Mock implements CouponRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VoucherListView', () {
    late VoucherListController controller;
    late MockCouponRepository couponRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          promoVoucher: 'Promo & Voucher',
          voucherAvailable: 'Available',
          voucherNotAvailable: 'Not Available',
          promoVoucherNotAvailable: 'No vouchers yet',
          noHaveAnyPromo: 'You have no promo vouchers',
        ),
      );
      couponRepository = MockCouponRepository();
      controller = VoucherListController(couponRepository: couponRepository);
      controller.isFetch.value = false;
      Get.put<VoucherListController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    Future<void> pumpVoucherListView(WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: VoucherListView()),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders voucher list screen content', (WidgetTester tester) async {
      await pumpVoucherListView(tester);

      expect(find.text('Promo & Voucher'), findsOneWidget);
      expect(find.text('Available'), findsOneWidget);
      expect(find.text('Not Available'), findsOneWidget);
    });

    testWidgets('renders empty state when voucher list is empty', (
      WidgetTester tester,
    ) async {
      controller.voucherList.clear();
      controller.isFetch.value = false;

      await pumpVoucherListView(tester);

      expect(find.text('No vouchers yet'), findsOneWidget);
      expect(find.text('You have no promo vouchers'), findsOneWidget);
    });
  });
}
