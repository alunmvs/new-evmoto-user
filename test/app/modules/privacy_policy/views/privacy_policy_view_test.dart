import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/agreement_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/privacy_policy/controllers/privacy_policy_controller.dart';
import 'package:new_evmoto_user/app/modules/privacy_policy/views/privacy_policy_view.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyView', () {
    late PrivacyPolicyController controller;
    late MockAgreementRepository agreementRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(privacyPolicy: 'Privacy Policy'),
      );
      agreementRepository = MockAgreementRepository();
      controller = PrivacyPolicyController(
        agreementRepository: agreementRepository,
      );
      Get.put<PrivacyPolicyController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('shows loading indicator when isFetch is true', (
      WidgetTester tester,
    ) async {
      controller.isFetch.value = true;

      await tester.pumpWidget(
        const GetMaterialApp(home: PrivacyPolicyView()),
      );
      await tester.pump();

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders agreement content when loaded', (
      WidgetTester tester,
    ) async {
      controller.isFetch.value = false;
      controller.agreement.value = Agreement(content: 'Policy content');

      await tester.pumpWidget(
        const GetMaterialApp(home: PrivacyPolicyView()),
      );
      await tester.pump();

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Policy content'), findsOneWidget);
    });
  });
}
