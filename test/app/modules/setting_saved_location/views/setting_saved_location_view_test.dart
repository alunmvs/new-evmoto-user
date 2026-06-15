import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/controllers/setting_saved_location_controller.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/views/setting_saved_location_view.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingSavedLocationView', () {
    late SettingSavedLocationController controller;
    late MockSavedAddressRepository savedAddressRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          settingSavedLocation: 'Saved Locations',
          addOtherAddress: 'Add Address',
          savedAddressNotFoundTitle: 'No saved addresses',
          savedAddressNotFoundDescription: 'Add your frequently used addresses',
        ),
      );
      savedAddressRepository = MockSavedAddressRepository();
      controller = SettingSavedLocationController(
        savedAddressRepository: savedAddressRepository,
      );
      controller.isFetch.value = false;
      controller.savedAddressList.clear();
      Get.put<SettingSavedLocationController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders saved location screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: SettingSavedLocationView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Saved Locations'), findsOneWidget);
      expect(find.text('Add Address'), findsOneWidget);
      expect(find.text('No saved addresses'), findsOneWidget);
      expect(find.text('Add your frequently used addresses'), findsOneWidget);
    });
  });
}
