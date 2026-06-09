import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';

import '../controllers/add_edit_user_information_controller.dart';

class AddEditUserInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddEditUserInformationController>(
      () => AddEditUserInformationController(
        uploadImageRepository: UploadImageRepository(),
        userRepository: UserRepository(),
      ),
    );
  }
}
