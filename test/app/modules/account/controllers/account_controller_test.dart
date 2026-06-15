import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountController', () {
    late AccountController controller;
    late MockOtpRepository otpRepository;
    late MockUserRepository userRepository;
    late MockOrderRideRepository orderRideRepository;

    setUp(() {
      registerCoreTestServices();
      registerMinimalHomeController(
        userRepository: userRepository = MockUserRepository(),
        orderRideRepository: orderRideRepository = MockOrderRideRepository(),
      );

      controller = AccountController(
        otpRepository: otpRepository = MockOtpRepository(),
        userRepository: userRepository,
        orderRideRepository: orderRideRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have empty package info and isFetch false before onInit', () {
      expect(controller.packageVersion.value, '');
      expect(controller.buildNumber.value, '');
      expect(controller.isFetch.value, false);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
