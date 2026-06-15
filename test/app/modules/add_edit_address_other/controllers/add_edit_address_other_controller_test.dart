import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address_other/controllers/add_edit_address_other_controller.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

class MockGeocodingRepository extends Mock implements GeocodingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditAddressOtherController', () {
    late AddEditAddressOtherController controller;
    late MockSavedAddressRepository savedAddressRepository;
    late MockGeocodingRepository geocodingRepository;

    setUp(() {
      registerCoreTestServices();
      registerFakeLocationServices();
      savedAddressRepository = MockSavedAddressRepository();
      geocodingRepository = MockGeocodingRepository();
      controller = AddEditAddressOtherController(
        savedAddressRepository: savedAddressRepository,
        geocodingRepository: geocodingRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.isEdit.value, false);
      expect(controller.addressType.value, 3);
      expect(controller.isFetch.value, false);
      expect(controller.isFormValid.value, false);
      expect(controller.formGroup.valid, false);
    });

    testWidgets('should populate form from saved_address arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {
        'saved_address': SavedAddress(
          id: 5,
          addressType: 3,
          addressDetail: 'Jl. Gatot Subroto',
          addressName: 'Gym',
          addressNotes: 'Floor 2',
          latitude: '-6.2',
          longitude: '106.8',
        ),
      };

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isEdit.value, true);
      expect(controller.addressType.value, 3);
      expect(controller.formGroup.control('address_name').value, 'Gym');
      expect(
        controller.formGroup.control('address_detail').value,
        'Jl. Gatot Subroto',
      );
      expect(controller.formGroup.control('address_notes').value, 'Floor 2');
      expect(controller.textEditingController.text, 'Jl. Gatot Subroto');
      expect(controller.maxLines.value, 3);
    });

    test('should update isFormValid when form and geocoding place are valid', () {
      controller.textEditingController = TextEditingController();
      controller.formGroup.control('address_name').value = 'Office';
      controller.formGroup.control('address_detail').value = 'Jl. Sudirman';
      controller.geocodingPlace.value = GeocodingPlace(address: 'Jl. Sudirman');

      controller.refreshIsFormValid();

      expect(controller.isFormValid.value, true);
    });

    test('should clean up without error when onClose is called', () {
      controller.textEditingController = TextEditingController();
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
