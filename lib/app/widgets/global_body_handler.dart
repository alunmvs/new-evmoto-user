import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class GlobalBodyHandler extends StatelessWidget {
  final bool isFetch;
  final bool isCriticalError;
  final Widget body;
  final Function onInit;

  GlobalBodyHandler({
    super.key,
    required this.isFetch,
    required this.isCriticalError,
    required this.body,
    required this.onInit,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  @override
  Widget build(BuildContext context) {
    return isFetch
        ? Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: themeColorServices.primaryBlue.value,
              ),
            ),
          )
        : isCriticalError
        ? Container(
            color: themeColorServices.neutralsColorGrey0.value,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (147 / 812),
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (176 / 375),
                    child: AspectRatio(
                      aspectRatio: 176 / 86,
                      child: Image.asset(
                        "assets/images/img_error.png",
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Maaf, terjadi kesalahan",
                  style: typographyServices.bodyLargeBold.value,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Sepertinya ada kendala di sistem kami. Silakan coba lagi atau kembali ke halaman sebelumnya.",
                  style: typographyServices.bodySmallRegular.value,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width * (204 / 374),
                  child: LoaderElevatedButton(
                    onPressed: () async {
                      await onInit();
                    },
                    child: Text(
                      "Coba Lagi",
                      style: typographyServices.bodyLargeBold.value.copyWith(
                        color: themeColorServices.neutralsColorGrey0.value,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : body;
  }
}
