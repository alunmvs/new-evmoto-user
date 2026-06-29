import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/gopay_balance_model.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_status_model.dart';
import 'package:new_evmoto_user/app/data/models/payment_method_model.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/repositories/payment_method_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';

class RideCheckoutSelectPaymentMethodController extends GetxController {
  static const payTypeGopay = 4;
  static const payTypeCash = 3;

  final PaymentMethodRepository paymentMethodRepository;
  final GopayPaymentRepository gopayPaymentRepository;
  final UserServices userServices;

  RideCheckoutSelectPaymentMethodController({
    required this.paymentMethodRepository,
    required this.gopayPaymentRepository,
    UserServices? userServices,
  }) : userServices = userServices ?? Get.find<UserServices>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final selectedPayType = Rx<int?>(null);
  final paymentMethodList = <PaymentMethod>[].obs;
  final gopayLinkStatus = GopayLinkStatus().obs;
  final gopayBalance = GopayBalance().obs;
  final isFetch = false.obs;
  final isLinkingGopay = false.obs;

  bool get isGopayLinked => gopayLinkStatus.value.linked == true;

  bool get isCashEnabled {
    final cashMethods = paymentMethodList.where(
      (method) => method.code == payTypeCash,
    );
    if (cashMethods.isEmpty) return true;
    return cashMethods.any((method) => method.enabled == true);
  }

  bool get isGopayEnabled {
    final gopayMethods = paymentMethodList.where(
      (method) => method.code == payTypeGopay,
    );
    if (gopayMethods.isEmpty) return true;
    return gopayMethods.any((method) => method.enabled == true);
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    selectedPayType.value = Get.arguments?['pay_type'] as int?;

    isFetch.value = true;
    try {
      await _loadPaymentData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isFetch.value = false;
  }

  Future<void> _loadPaymentData() async {
    paymentMethodList.value = await paymentMethodRepository
        .getPaymentMethodList();
    gopayLinkStatus.value = await gopayPaymentRepository.getGopayLinkStatus();

    if (gopayLinkStatus.value.linked == true) {
      gopayBalance.value = await gopayPaymentRepository.getGopayBalance();
    } else {
      gopayBalance.value = GopayBalance();
    }
  }

  void selectPayType(int payType) {
    if (payType == payTypeGopay && !isGopayLinked) {
      SnackbarHelper.showSnackbarError(
        text:
            "GoPay belum aktif. Silahkan lakukan aktivasi untuk menggunakan metode pembayaran ini.",
      );
      return;
    }

    selectedPayType.value = payType;

    if (payType == payTypeCash) {
      SnackbarHelper.showSnackbarSuccess(
        text: "Pembayaran cash berhasil dipilih sebagai metode pembayaran.",
      );
    } else if (payType == payTypeGopay) {
      SnackbarHelper.showSnackbarSuccess(
        text: "Pembayaran GoPay berhasil dipilih sebagai metode pembayaran.",
      );
    }

    Get.back(result: payType);
  }

  ({String phoneNumber, String countryCode}) _parsePhoneFromUserServices() {
    var phone = (userServices.userInfo.value.phone ?? "").removeAllWhitespace;

    if (phone.isEmpty) {
      throw "Nomor telepon tidak ditemukan";
    }

    if (phone.startsWith("62")) {
      return (phoneNumber: phone.substring(2), countryCode: "62");
    }

    if (phone.startsWith("0")) {
      return (phoneNumber: phone.substring(1), countryCode: "62");
    }

    return (phoneNumber: phone, countryCode: "62");
  }

  Future<void> onTapActivateGopay() async {
    if (isLinkingGopay.value) return;

    isLinkingGopay.value = true;
    try {
      await userServices.getUserInfo();
      final parsedPhone = _parsePhoneFromUserServices();

      final linkData = await gopayPaymentRepository.linkGopay(
        phoneNumber: parsedPhone.phoneNumber,
        countryCode: parsedPhone.countryCode,
      );

      final activationUrl = linkData.activationUrl;
      if (activationUrl == null || activationUrl.isEmpty) {
        throw "URL aktivasi GoPay tidak ditemukan";
      }

      await Get.toNamed(
        Routes.GOPAY_ACTIVATION_WEBVIEW,
        arguments: {"activation_url": activationUrl},
      );

      await _loadPaymentData();
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isLinkingGopay.value = false;
  }
}
