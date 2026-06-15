import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/onboarding_registration_form/controllers/onboarding_registration_form_controller.dart';
import 'package:new_evmoto_user/app/modules/onboarding_registration_form/views/onboarding_registration_form_view.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockUserRepository extends Mock implements UserRepository {}

class TestOnboardingRegistrationFormController
    extends OnboardingRegistrationFormController {
  TestOnboardingRegistrationFormController({required super.userRepository});

  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingRegistrationFormView', () {
    late TestOnboardingRegistrationFormController controller;
    late MockUserRepository userRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          whatName: 'What is your name?',
          canProvideBestService: 'So we can provide the best service',
          enterNameRegistrationForm: 'Enter your name',
          save: 'Save',
          requiredFields: 'This field is required',
          maxCharacter20: 'Maximum 20 characters',
        ),
      );
      registerTestUserServices();
      userRepository = MockUserRepository();
      controller = TestOnboardingRegistrationFormController(
        userRepository: userRepository,
      );
      controller.isFetch.value = false;
      Get.put<OnboardingRegistrationFormController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders onboarding registration form content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: OnboardingRegistrationFormView()),
      );
      await tester.pump();

      expect(find.text('What is your name?'), findsOneWidget);
      expect(find.text('So we can provide the best service'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
