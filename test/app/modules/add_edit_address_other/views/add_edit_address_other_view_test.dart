import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address_other/controllers/add_edit_address_other_controller.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address_other/views/add_edit_address_other_view.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

class MockGeocodingRepository extends Mock implements GeocodingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditAddressOtherView', () {
    late AddEditAddressOtherController controller;
    late MockSavedAddressRepository savedAddressRepository;
    late MockGeocodingRepository geocodingRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          enterName: 'Enter location name',
          enterLocationOtherAddress: 'Search other address',
          saveAddress: 'Save Address',
        ),
      );
      registerFakeLocationServices();
      savedAddressRepository = MockSavedAddressRepository();
      geocodingRepository = MockGeocodingRepository();
      controller = AddEditAddressOtherController(
        savedAddressRepository: savedAddressRepository,
        geocodingRepository: geocodingRepository,
      );
      controller.isFetch.value = false;
      controller.textEditingController = TextEditingController();
      Get.put<AddEditAddressOtherController>(controller);
    });

    tearDown(() {
      controller.textEditingController.dispose();
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders add other address screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AddEditAddressOtherView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tambah Lokasi Lainnya'), findsOneWidget);
      expect(find.text('Nama Lokasi'), findsOneWidget);
      expect(find.text('Masukan Lokasi'), findsOneWidget);
      expect(find.text('Enter location name'), findsOneWidget);
      expect(find.text('Search other address'), findsOneWidget);
      expect(find.text('Save Address'), findsOneWidget);
    });
  });
}
