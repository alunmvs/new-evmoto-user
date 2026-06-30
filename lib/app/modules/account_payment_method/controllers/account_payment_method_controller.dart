import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/gopay_balance_model.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_status_model.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AccountPaymentMethodController extends GetxController {
  final GopayPaymentRepository gopayPaymentRepository;

  AccountPaymentMethodController({required this.gopayPaymentRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final userServices = Get.find<UserServices>();

  final refreshController = RefreshController();
  final isFetch = false.obs;
  final gopayLinkStatus = GopayLinkStatus().obs;
  final gopayBalance = GopayBalance().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    try {
      await getGopayData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
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
    try {
      await getGopayData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
  }

  Future<void> getGopayData() async {
    gopayLinkStatus.value = await gopayPaymentRepository.getGopayLinkStatus();

    if (gopayLinkStatus.value.linked == true) {
      gopayBalance.value = await gopayPaymentRepository.getGopayBalance();
    } else {
      gopayBalance.value = GopayBalance();
    }
  }

  Future<void> onTapGopayDetail() async {
    await Get.toNamed(Routes.ACCOUNT_PAYMENT_METHOD_GOPAY_DETAIL);
    await refreshAll();
  }

  Future<void> onTapAddPaymentMethod() async {
    await Get.toNamed(Routes.ADD_ACCOUNT_PAYMENT_METHOD);
    await refreshAll();
  }
}
