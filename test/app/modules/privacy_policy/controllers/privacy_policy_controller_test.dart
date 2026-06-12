import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/agreement_model.dart';
import 'package:new_evmoto_user/app/modules/privacy_policy/controllers/privacy_policy_controller.dart';
import 'package:new_evmoto_user/app/repositories/agreement_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockAgreementRepository extends Mock implements AgreementRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrivacyPolicyController', () {
    late PrivacyPolicyController controller;
    late MockAgreementRepository agreementRepository;

    setUp(() {
      registerCoreTestServices();
      agreementRepository = MockAgreementRepository();
      controller = PrivacyPolicyController(
        agreementRepository: agreementRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have empty agreement and isFetch false before onInit', () {
      expect(controller.agreement.value.content, isNull);
      expect(controller.isFetch.value, false);
    });

    testWidgets('should load privacy policy agreement on onInit', (
      WidgetTester tester,
    ) async {
      when(
        () => agreementRepository.getAgreementDetail(
          language: any(named: 'language'),
          userType: any(named: 'userType'),
          type: any(named: 'type'),
        ),
      ).thenAnswer(
        (_) async => Agreement(content: '<p>Privacy Policy</p>'),
      );

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isFetch.value, false);
      expect(controller.agreement.value.content, '<p>Privacy Policy</p>');
      verify(
        () => agreementRepository.getAgreementDetail(
          language: 2,
          userType: 1,
          type: 1,
        ),
      ).called(1);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
