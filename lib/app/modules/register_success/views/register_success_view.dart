import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/register_success_controller.dart';

class RegisterSuccessView extends GetView<RegisterSuccessController> {
  const RegisterSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterSuccessView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/img_register_success.png",
              width: 85,
              height: 85,
            ),
            SizedBox(height: 16),
            Text(
              "Pendaftaran Berhasil",
              style: controller.typographyServices.headingMediumBold.value
                  .copyWith(color: Color(0XFF272727)),
            ),
            Text(
              "Selamat, akun anda telah berhasil dibuat.",
              style: controller.typographyServices.bodySmallRegular.value
                  .copyWith(color: Color(0XFFB3B3B3)),
            ),
            SizedBox(height: 32),
            Text(
              "Kode refferal benar",
              style: controller.typographyServices.headingMediumBold.value
                  .copyWith(color: Color(0XFF2E2E2E)),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0XFF0060C6)),
              ),
              child: Text(
                "DRV - 00842",
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(color: Color(0XFF0060C6), fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 78,
        shadowColor: controller.themeColorServices.overlayDark100.value
            .withValues(alpha: 0.1),
        color: controller.themeColorServices.neutralsColorGrey0.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoaderElevatedButton(
              onPressed: () async {},
              child: Text(
                "Homepage",
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
