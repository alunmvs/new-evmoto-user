import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address/controllers/add_edit_address_controller.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditAddressController', () {
    late AddEditAddressController controller;
    late MockSavedAddressRepository savedAddressRepository;

    setUp(() {
      registerCoreTestServices();
      savedAddressRepository = MockSavedAddressRepository();
      controller = AddEditAddressController(
        savedAddressRepository: savedAddressRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.isEdit.value, false);
      expect(controller.addressType.value, 0);
      expect(controller.isFetch.value, false);
      expect(controller.formGroup.valid, false);
    });

    testWidgets('should populate form from geocoding_place arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {
        'geocoding_place': GeocodingPlace(
          address: 'Jl. Sudirman',
          name: 'Sudirman',
          lat: -6.2,
          lng: 106.8,
        ),
        'address_type': 1,
      };

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isEdit.value, false);
      expect(controller.addressType.value, 1);
      expect(controller.formGroup.control('address_detail').value, 'Jl. Sudirman');
      expect(controller.isFetch.value, false);
    });

    testWidgets('should populate form from saved_address arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {
        'saved_address': SavedAddress(
          id: 1,
          addressType: 2,
          addressDetail: 'Jl. Thamrin',
          addressName: 'Office',
          addressNotes: 'Near lobby',
        ),
      };

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isEdit.value, true);
      expect(controller.addressType.value, 2);
      expect(controller.formGroup.control('address_name').value, 'Office');
      expect(controller.formGroup.control('address_detail').value, 'Jl. Thamrin');
      expect(controller.formGroup.control('address_notes').value, 'Near lobby');
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
