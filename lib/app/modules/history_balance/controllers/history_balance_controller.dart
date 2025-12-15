import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/balance_history_consumption_model.dart';
import 'package:new_evmoto_user/app/data/balance_history_deposit_model.dart';
import 'package:new_evmoto_user/app/repositories/payment_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HistoryBalanceController extends GetxController {
  final PaymentRepository paymentRepository;

  HistoryBalanceController({required this.paymentRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final balanceHistoryConsumptionList = <BalanceHistoryConsumption>[].obs;
  final balanceHistoryConsumptionPageNum = 1.obs;
  final balanceHistoryConsumptionSize = 20.obs;
  final balanceHistoryConsumptionSeeMore = true.obs;
  final balanceHistoryDepositList = <BalanceHistoryDeposit>[].obs;
  final balanceHistoryDepositPageNum = 1.obs;
  final balanceHistoryDepositSize = 20.obs;
  final balanceHistoryDepositSeeMore = true.obs;

  final balanceHistoryListByDate = {}.obs;
  final sortedBalanceHistoryListByDate = {}.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await Future.wait([
      getBalanceHistoryConsumptionList(),
      getBalanceHistoryDepositList(),
    ]);

    getBalanceHistoryListByDate();
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

  Future<void> refreshAll() async {
    await Future.wait([
      getBalanceHistoryConsumptionList(),
      getBalanceHistoryDepositList(),
    ]);

    getBalanceHistoryListByDate();
  }

  Future<void> getBalanceHistoryConsumptionList() async {
    balanceHistoryConsumptionPageNum.value = 1;
    balanceHistoryConsumptionSeeMore.value = true;

    balanceHistoryConsumptionList.value = await paymentRepository
        .getBalanceHistoryConsumption(
          pageNum: balanceHistoryConsumptionPageNum.value,
          size: balanceHistoryConsumptionSize.value,
          language: languageServices.languageCodeSystem.value,
        );
  }

  Future<void> getBalanceHistoryDepositList() async {
    balanceHistoryDepositPageNum.value = 1;
    balanceHistoryDepositSeeMore.value = true;

    balanceHistoryDepositList.value = await paymentRepository
        .getBalanceHistoryDeposit(
          pageNum: balanceHistoryDepositPageNum.value,
          size: balanceHistoryDepositSize.value,
          language: languageServices.languageCodeSystem.value,
        );
  }

  Future<void> seeMoreBalanceHistoryConsumptionList() async {
    balanceHistoryConsumptionPageNum.value += 1;

    var balanceHistoryConsumptionList = await paymentRepository
        .getBalanceHistoryConsumption(
          pageNum: balanceHistoryConsumptionPageNum.value,
          size: balanceHistoryConsumptionSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (balanceHistoryConsumptionList.isEmpty) {
      balanceHistoryConsumptionSeeMore.value = false;
    }

    this.balanceHistoryConsumptionList.addAll(balanceHistoryConsumptionList);
  }

  Future<void> seeMoreBalanceHistoryDepositList() async {
    balanceHistoryDepositPageNum.value += 1;

    var balanceHistoryDepositList = await paymentRepository
        .getBalanceHistoryDeposit(
          pageNum: balanceHistoryDepositPageNum.value,
          size: balanceHistoryDepositSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (balanceHistoryDepositList.isEmpty) {
      balanceHistoryConsumptionSeeMore.value = false;
    }

    this.balanceHistoryDepositList.addAll(balanceHistoryDepositList);
  }

  Future<void> seeMoreAll() async {
    await Future.wait([
      seeMoreBalanceHistoryConsumptionList(),
      seeMoreBalanceHistoryDepositList(),
    ]);

    getBalanceHistoryListByDate();
  }

  void getBalanceHistoryListByDate() {
    balanceHistoryListByDate.clear();

    for (var balanceHistoryConsumption in balanceHistoryConsumptionList) {
      var createTimeKey = DateTime(
        balanceHistoryConsumption.createTimeDateTime!.year,
        balanceHistoryConsumption.createTimeDateTime!.month,
        balanceHistoryConsumption.createTimeDateTime!.day,
      );

      if (balanceHistoryListByDate.containsKey(createTimeKey) == false) {
        balanceHistoryListByDate[createTimeKey] = [];
      }

      balanceHistoryListByDate[createTimeKey].add(balanceHistoryConsumption);
    }

    for (var balancehistoryDeposit in balanceHistoryDepositList) {
      var createTimeKey = DateTime(
        balancehistoryDeposit.createTimeDateTime!.year,
        balancehistoryDeposit.createTimeDateTime!.month,
        balancehistoryDeposit.createTimeDateTime!.day,
      );

      if (balanceHistoryListByDate.containsKey(createTimeKey) == false) {
        balanceHistoryListByDate[createTimeKey] = [];
      }

      balanceHistoryListByDate[createTimeKey].add(balancehistoryDeposit);
    }

    sortedBalanceHistoryListByDate.clear();

    sortedBalanceHistoryListByDate.value = Map.fromEntries(
      balanceHistoryListByDate.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  List getSortedBalanceHistoryList({required DateTime createTimeKey}) {
    return balanceHistoryListByDate[createTimeKey].sort(
      (a, b) => b.createTimeDateTime.compareTo(a.createTimeDateTime),
    );
  }
}
