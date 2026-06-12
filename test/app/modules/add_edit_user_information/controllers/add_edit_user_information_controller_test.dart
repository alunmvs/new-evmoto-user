import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_user_information/controllers/add_edit_user_information_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditUserInformationController', () {
    late AddEditUserInformationController controller;

    setUp(() {
      registerCoreTestServices();
      registerMinimalHomeController(
        userInfo: UserInfo(
          id: 1,
          name: 'Jane Doe',
          phone: '628987654321',
          sex: 1,
          avatar: 'https://example.com/avatar.png',
        ),
      );

      controller = AddEditUserInformationController(
        uploadImageRepository: MockUploadImageRepository(),
        userRepository: MockUserRepository(),
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.avatarImgUrl.value, '');
      expect(controller.isFetch.value, false);
      expect(controller.formGroup.valid, false);
    });

    testWidgets('should prefill form from user info on onInit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.formGroup.control('full_name').value, 'Jane Doe');
      expect(controller.formGroup.control('mobile_number').value, '628987654321');
      expect(controller.formGroup.control('gender_type').value, 1);
      expect(controller.avatarImgUrl.value, 'https://example.com/avatar.png');
      expect(controller.isFetch.value, false);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
