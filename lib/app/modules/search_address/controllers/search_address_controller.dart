import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

class SearchAddressController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final addressType = "".obs;
  final keyword = "".obs;
  late TextEditingController textEditingController;

  final highlightedWordTitleAddress = <String, HighlightedWord>{}.obs;
  final highlightedWordAddress = <String, HighlightedWord>{}.obs;
  final isDisplaySearchAddressPinnedTop = false.obs;

  @override
  void onInit() {
    super.onInit();
    addressType.value = Get.arguments['address_type'] ?? "";
    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      keyword.value = textEditingController.text;
      highlightedWordTitleAddress.clear();
      highlightedWordAddress.clear();
      for (var word in keyword.value.split(" ")) {
        highlightedWordTitleAddress[word] = HighlightedWord(
          onTap: () {},
          textStyle: typographyServices.bodySmallBold.value.copyWith(
            color: themeColorServices.primaryBlue.value,
          ),
        );

        highlightedWordAddress[word] = HighlightedWord(
          onTap: () {},
          textStyle: typographyServices.captionLargeRegular.value.copyWith(
            color: themeColorServices.primaryBlue.value,
          ),
        );
      }

      highlightedWordTitleAddress.refresh();
      highlightedWordAddress.refresh();
      isDisplaySearchAddressPinnedTop.refresh();
    });
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
