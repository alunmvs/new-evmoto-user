import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/agreement_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/terms_and_conditions/controllers/terms_and_conditions_controller.dart';
import 'package:new_evmoto_user/app/modules/terms_and_conditions/views/terms_and_conditions_view.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TermsAndConditionsView', () {
    late TermsAndConditionsController controller;
    late MockAgreementRepository agreementRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(termAndCondition: 'Terms & Conditions'),
      );
      agreementRepository = MockAgreementRepository();
      controller = TermsAndConditionsController(
        agreementRepository: agreementRepository,
      );
      Get.put<TermsAndConditionsController>(controller);
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
        const GetMaterialApp(home: TermsAndConditionsView()),
      );
      await tester.pump();

      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders agreement content when loaded', (
      WidgetTester tester,
    ) async {
      controller.isFetch.value = false;
      controller.agreement.value = Agreement(content: 'Terms content');

      await tester.pumpWidget(
        const GetMaterialApp(home: TermsAndConditionsView()),
      );
      await tester.pump();

      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text('Terms content'), findsOneWidget);
    });
  });
}
