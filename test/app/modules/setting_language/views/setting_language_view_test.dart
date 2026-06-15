import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/setting_language/controllers/setting_language_controller.dart';
import 'package:new_evmoto_user/app/modules/setting_language/views/setting_language_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingLanguageView', () {
    late SettingLanguageController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
        languageCode: 'ID',
      );
      controller = SettingLanguageController();
      controller.onInit();
      Get.put<SettingLanguageController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders language selection screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: SettingLanguageView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('简体中文 (ZH_CN)'), findsOneWidget);
      expect(find.text('English (EN)'), findsOneWidget);
      expect(find.text('Bahasa Indonesia (ID)'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('updates selected language when option is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: SettingLanguageView()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('English (EN)'));
      await tester.pump();

      expect(controller.tempLanguageCode.value, 'EN');
    });
  });
}
