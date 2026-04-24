import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/views/ride_order_cancel_view/ride_order_cancel_reason_list_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/ride_order_cancel_controller.dart';

class RideOrderCancelView extends GetView<RideOrderCancelController> {
  const RideOrderCancelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.cancelOrder ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ReactiveForm(
              formGroup: controller.formGroup,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .cancelOrderConfirmationTitle ??
                        "-",
                    style: controller.typographyServices.bodyLargeBold.value,
                  ),
                  SizedBox(height: 4),
                  RideOrderCancelReasonListSubView(),
                  SizedBox(height: 16),
                  ReactiveTextField(
                    formControlName: 'remark',
                    maxLines: 3,
                    style: controller.typographyServices.bodySmallRegular.value,
                    cursorErrorColor:
                        controller.themeColorServices.primaryBlue.value,
                    decoration: InputDecoration(
                      hintText:
                          controller
                              .languageServices
                              .language
                              .value
                              .cancelOrderConfirmationDescription ??
                          "-",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),

                      hintStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                          ),
                      errorStyle: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .sematicColorRed500
                                .value,
                          ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .sematicColorRed500
                              .value,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .sematicColorRed500
                              .value,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey400
                              .value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validationMessages: {
                      ValidationMessage.maxLength: (error) =>
                          controller
                              .languageServices
                              .language
                              .value
                              .maxCharacter150 ??
                          "-",
                    },
                  ),
                  SizedBox(height: 16 * 2),
                ],
              ),
            ),
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
                onPressed: () async {
                  await controller.onTapSubmit();
                },
                child: Text(
                  controller.languageServices.language.value.cancel ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
