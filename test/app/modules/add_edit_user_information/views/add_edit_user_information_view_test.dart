import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/add_edit_user_information/controllers/add_edit_user_information_controller.dart';
import 'package:new_evmoto_user/app/modules/add_edit_user_information/views/add_edit_user_information_view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditUserInformationView', () {
    late AddEditUserInformationController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          changeUserInformation: 'Change User Information',
          avatarPhoto: 'Avatar Photo',
          fullName: 'Full Name',
          enterFullName: 'Enter full name',
          gender: 'Gender',
          man: 'Man',
          woman: 'Woman',
          selectGender: 'Select gender',
          mobilePhoneNumber: 'Mobile Phone Number',
          enterMobileNumber: 'Enter mobile number',
          save: 'Save',
        ),
      );
      registerMinimalHomeController(
        userInfo: UserInfo(
          id: 1,
          name: 'Jane Doe',
          phone: '628987654321',
          sex: 1,
        ),
      );

      controller = AddEditUserInformationController(
        uploadImageRepository: MockUploadImageRepository(),
        userRepository: MockUserRepository(),
      );
      controller.isFetch.value = false;
      controller.formGroup.control('full_name').value = 'Jane Doe';
      controller.formGroup.control('mobile_number').value = '628987654321';
      controller.formGroup.control('gender_type').value = 1;
      Get.put<AddEditUserInformationController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders edit user information screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: AddEditUserInformationView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change User Information'), findsOneWidget);
      expect(find.text('Avatar Photo'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Mobile Phone Number'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsOneWidget);
    });
  });
}
