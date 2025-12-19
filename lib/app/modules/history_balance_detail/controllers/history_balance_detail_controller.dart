import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/balance_history_consumption_model.dart';
import 'package:new_evmoto_user/app/data/models/balance_history_deposit_model.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class HistoryBalanceDetailController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final balanceHistoryConsumption = BalanceHistoryConsumption().obs;
  final balanceHistoryDeposit = BalanceHistoryDeposit().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    balanceHistoryConsumption.value =
        Get.arguments['balance_history_consumption'] ??
        BalanceHistoryConsumption();
    balanceHistoryDeposit.value =
        Get.arguments['balance_history_deposit'] ?? BalanceHistoryDeposit();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
