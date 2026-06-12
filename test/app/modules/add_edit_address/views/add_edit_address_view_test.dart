import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address/controllers/add_edit_address_controller.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address/views/add_edit_address_view.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditAddressView', () {
    late AddEditAddressController controller;
    late MockSavedAddressRepository savedAddressRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          locationDetails: 'Location Details',
          locationName: 'Location Name',
          enterName: 'Enter name',
          enterLocation: 'Enter location',
          saveAddress: 'Save Address',
        ),
      );
      savedAddressRepository = MockSavedAddressRepository();
      controller = TestAddEditAddressController(
        savedAddressRepository: savedAddressRepository,
      );
      controller.isFetch.value = false;
      controller.geocodingPlace.value = GeocodingPlace(address: 'Jl. Sudirman');
      controller.formGroup.control('address_detail').value = 'Jl. Sudirman';
      Get.put<AddEditAddressController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders add address screen content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AddEditAddressView()),
      );
      await tester.pump();

      expect(find.text('Location Details'), findsOneWidget);
      expect(find.text('Location Name'), findsOneWidget);
      expect(find.text('Save Address'), findsOneWidget);
    });
  });
}
