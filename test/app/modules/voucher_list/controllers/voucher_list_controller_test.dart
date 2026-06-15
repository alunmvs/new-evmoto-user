import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/modules/voucher_list/controllers/voucher_list_controller.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockCouponRepository extends Mock implements CouponRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VoucherListController', () {
    late VoucherListController controller;
    late MockCouponRepository couponRepository;

    setUp(() {
      registerCoreTestServices(languageCodeSystem: 2);
      couponRepository = MockCouponRepository();
      controller = VoucherListController(couponRepository: couponRepository);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.voucherList, isEmpty);
      expect(controller.isSeeMoreVoucherList.value, true);
      expect(controller.pageNum.value, 1);
      expect(controller.size.value, 10);
      expect(controller.selectedIndex.value, 1);
      expect(controller.isFetch.value, false);
    });

    test('should load voucher list on getVoucherList', () async {
      final coupons = [Coupon(id: 1, name: 'Summer Promo')];

      when(
        () => couponRepository.getCouponList(
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          language: any(named: 'language'),
          state: any(named: 'state'),
          priceNo: any(named: 'priceNo'),
        ),
      ).thenAnswer((_) async => coupons);

      await controller.getVoucherList();

      expect(controller.voucherList, coupons);
      expect(controller.pageNum.value, 1);
      expect(controller.isSeeMoreVoucherList.value, true);
      verify(
        () => couponRepository.getCouponList(
          pageNum: 1,
          size: 10,
          language: 2,
          state: 1,
          priceNo: null,
        ),
      ).called(1);
    });

    test('should increment pageNum on seeMoreVoucherList', () async {
      when(
        () => couponRepository.getCouponList(
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          language: any(named: 'language'),
          state: any(named: 'state'),
          priceNo: any(named: 'priceNo'),
        ),
      ).thenAnswer((_) async => [Coupon(id: 2, name: 'Extra Voucher')]);

      await controller.seeMoreVoucherList();

      expect(controller.pageNum.value, 2);
      verify(
        () => couponRepository.getCouponList(
          pageNum: 2,
          size: 10,
          language: 2,
          state: 1,
          priceNo: null,
        ),
      ).called(1);
    });

    test('should set isSeeMoreVoucherList false when see more returns empty', () async {
      when(
        () => couponRepository.getCouponList(
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          language: any(named: 'language'),
          state: any(named: 'state'),
          priceNo: any(named: 'priceNo'),
        ),
      ).thenAnswer((_) async => []);

      await controller.seeMoreVoucherList();

      expect(controller.isSeeMoreVoucherList.value, false);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
