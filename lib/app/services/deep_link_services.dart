import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DeepLinkServices extends GetxService {
  final appLinks = AppLinks();

  @override
  Future<void> onInit() async {
    super.onInit();

    appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == "evmoto") {
        Get.toNamed(uri.host, arguments: uri.queryParameters);
      }
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
