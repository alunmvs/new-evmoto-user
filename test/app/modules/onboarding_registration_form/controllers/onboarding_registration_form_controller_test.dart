import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/onboarding_registration_form/controllers/onboarding_registration_form_controller.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingRegistrationFormController', () {
    late OnboardingRegistrationFormController controller;
    late MockUserRepository userRepository;

    setUp(() {
      registerCoreTestServices();
      registerTestUserServices();
      userRepository = MockUserRepository();
      controller = OnboardingRegistrationFormController(
        userRepository: userRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.formGroup.valid, false);
      expect(controller.userInfo.value.id, isNull);
      expect(controller.isFetch.value, false);
    });

    test('should load user info from repository on getUserInfo', () async {
      when(
        () => userRepository.getUserInfo(language: any(named: 'language')),
      ).thenAnswer((_) async => UserInfo(id: 42, name: 'Jane Doe'));

      await controller.getUserInfo();

      expect(controller.userInfo.value.id, 42);
      expect(controller.userInfo.value.name, 'Jane Doe');
    });

    test('should keep form invalid when full name is empty on submit', () async {
      controller.userInfo.value = UserInfo(id: 1);
      controller.formGroup.control('full_name').value = '';

      await controller.onTapSubmit();

      expect(controller.formGroup.valid, false);
      verifyNever(
        () => userRepository.updateName(name: any(named: 'name'), id: any(named: 'id')),
      );
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
