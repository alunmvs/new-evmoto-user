import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/gopay_link_status_model.dart';
import 'package:new_evmoto_user/app/repositories/gopay_payment_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';

class AddAccountPaymentMethodController extends GetxController {
  final GopayPaymentRepository gopayPaymentRepository;
  final UserServices userServices;

  AddAccountPaymentMethodController({
    required this.gopayPaymentRepository,
    UserServices? userServices,
  }) : userServices = userServices ?? Get.find<UserServices>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final isFetch = false.obs;
  final isLinkingGopay = false.obs;
  final gopayLinkStatus = GopayLinkStatus().obs;

  bool get isGopayLinked => gopayLinkStatus.value.linked == true;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    try {
      await Future.wait([userServices.getUserInfo(), _fetchGopayLinkStatus()]);
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isFetch.value = false;
  }

  Future<void> _fetchGopayLinkStatus() async {
    gopayLinkStatus.value = await gopayPaymentRepository.getGopayLinkStatus();
  }

  String get displayPhoneNumber {
    final phone = userServices.userInfo.value.phone ?? "";
    if (phone.isEmpty) return "-";
    return phone.startsWith("62") ? "+$phone" : "+62$phone";
  }

  ({String phoneNumber, String countryCode}) _parsePhoneFromUserServices() {
    var phone = (userServices.userInfo.value.phone ?? "").removeAllWhitespace;

    if (phone.isEmpty) {
      throw languageServices
              .language
              .value
              .addPaymentMethodMobileNumberNotFound ??
          "-";
    }

    if (phone.startsWith("62")) {
      return (phoneNumber: phone.substring(2), countryCode: "62");
    }

    if (phone.startsWith("0")) {
      return (phoneNumber: phone.substring(1), countryCode: "62");
    }

    return (phoneNumber: phone, countryCode: "62");
  }

  Future<void> onTapGopay() async {
    if (isLinkingGopay.value) return;

    isLinkingGopay.value = true;
    try {
      final parsedPhone = _parsePhoneFromUserServices();

      final linkData = await gopayPaymentRepository.linkGopay(
        phoneNumber: parsedPhone.phoneNumber,
        countryCode: parsedPhone.countryCode,
      );

      final activationUrl = linkData.activationUrl;
      if (activationUrl == null || activationUrl.isEmpty) {
        throw languageServices
                .language
                .value
                .addPaymentMethodUrlActivationNotFound ??
            "-";
      }

      await Get.toNamed(
        Routes.GOPAY_ACTIVATION_WEBVIEW,
        arguments: {"activation_url": activationUrl},
      );
    } on DioException catch (e) {
      SnackbarHelper.showSnackbarError(text: e.error.toString());
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: e.toString());
    }
    isLinkingGopay.value = false;
  }
}
