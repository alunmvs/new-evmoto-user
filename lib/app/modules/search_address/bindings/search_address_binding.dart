import 'package:get/get.dart';

import '../controllers/search_address_controller.dart';

class SearchAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchAddressController>(
      () => SearchAddressController(),
    );
  }
}
