import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';

class UserServices extends GetxService {
  final userRepository = UserRepository();
  final languageServices = Get.find<LanguageServices>();

  final userInfo = UserInfo().obs;

  final isLoadingRefreshHome = false.obs;

  Future<void> manualOnInit() async {
    await getUserInfo();
  }

  Future<void> getUserInfo() async {
    userInfo.value = (await userRepository.getUserInfo(
      language: languageServices.languageCodeSystem.value,
    ));
  }

  void clearUserInfo() {
    userInfo.value = UserInfo();
  }
}
