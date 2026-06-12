import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/setting_language/controllers/setting_language_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingLanguageController', () {
    late SettingLanguageController controller;

    setUp(() {
      registerCoreTestServices(languageCode: 'EN');
      controller = SettingLanguageController();
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have empty tempLanguageCode before onInit', () {
      expect(controller.tempLanguageCode.value, '');
    });

    test('should copy current language code on onInit', () {
      controller.onInit();

      expect(controller.tempLanguageCode.value, 'EN');
    });

    test('should update tempLanguageCode when language is selected', () {
      controller.onInit();
      controller.tempLanguageCode.value = 'ID';

      expect(controller.tempLanguageCode.value, 'ID');
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
