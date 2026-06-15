import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/saved_address_model.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/controllers/setting_saved_location_controller.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingSavedLocationController', () {
    late SettingSavedLocationController controller;
    late MockSavedAddressRepository savedAddressRepository;

    setUp(() {
      registerCoreTestServices();
      savedAddressRepository = MockSavedAddressRepository();
      controller = SettingSavedLocationController(
        savedAddressRepository: savedAddressRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.savedAddressList, isEmpty);
      expect(controller.isFetch.value, false);
    });

    test('should load saved address list from repository', () async {
      final addresses = [
        SavedAddress(
          id: 1,
          addressName: 'Home',
          addressDetail: 'Jl. Merdeka 1',
          addressType: 1,
        ),
      ];

      when(() => savedAddressRepository.getSavedAddressList())
          .thenAnswer((_) async => addresses);

      await controller.getSavedAddressList();

      expect(controller.savedAddressList, addresses);
      verify(() => savedAddressRepository.getSavedAddressList()).called(1);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
