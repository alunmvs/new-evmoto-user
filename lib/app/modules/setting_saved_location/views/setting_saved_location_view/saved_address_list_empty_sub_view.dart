import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/setting_saved_location/controllers/setting_saved_location_controller.dart';

class SavedAddressListEmptySubView
    extends GetView<SettingSavedLocationController> {
  const SavedAddressListEmptySubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller
                      .languageServices
                      .language
                      .value
                      .savedAddressNotFoundTitle ??
                  "-",
              style: controller.typographyServices.bodyLargeBold.value,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              controller
                      .languageServices
                      .language
                      .value
                      .savedAddressNotFoundDescription ??
                  "-",
              style: controller.typographyServices.bodySmallRegular.value,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
