import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
            "Batalkan Pesanan",
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
                    "Why did you cancel your order?",
                    style: controller.typographyServices.bodyLargeBold.value,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Please let us know and we can improve",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                  ),
                  SizedBox(height: 16),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value ==
                              "I don't need car for the time being due to a change in intinerary"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value:
                        'I don\'t need car for the time being due to a change in intinerary',
                    title: Text(
                      'I don\'t need car for the time being due to a change in intinerary',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value ==
                              "In a hurry, I need to change use other means of transportation"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value:
                        'In a hurry, I need to change use other means of transportation',
                    title: Text(
                      'In a hurry, I need to change use other means of transportation',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value ==
                              "The vehicle dispatched by the platform is too far"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value: 'The vehicle dispatched by the platform is too far',
                    title: Text(
                      'The vehicle dispatched by the platform is too far',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value ==
                              "The driver didn\'t come to pick me up for various reasons"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value:
                        'The driver didn\'t come to pick me up for various reasons',
                    title: Text(
                      'The driver didn\'t come to pick me up for various reasons',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value == "Can\'t contact the driver"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value: 'Can\'t contact the driver',
                    title: Text(
                      'Can\'t contact the driver',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value ==
                              "Driver asks for fare increase or transact by cash"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value: 'Driver asks for fare increase or transact by cash',
                    title: Text(
                      'Driver asks for fare increase or transact by cash',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value == "Driver is late"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value: 'Driver is late',
                    title: Text(
                      'Driver is late',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  ReactiveRadioListTile<String>(
                    formControlName: 'reason',
                    contentPadding: EdgeInsets.all(0),
                    fillColor: WidgetStatePropertyAll(
                      controller.reason.value == "Other"
                          ? controller.themeColorServices.primaryBlue.value
                          : controller
                                .themeColorServices
                                .neutralsColorGrey400
                                .value,
                    ),
                    onChanged: (control) {
                      controller.reason.value = control.value!;
                    },
                    value: 'Other',
                    title: Text(
                      'Other',
                      style: controller.typographyServices.bodySmallBold.value,
                    ),
                  ),
                  SizedBox(height: 16),
                  ReactiveTextField(
                    formControlName: 'remark',
                    maxLines: 3,
                    style: controller.typographyServices.bodySmallRegular.value,
                    cursorErrorColor:
                        controller.themeColorServices.primaryBlue.value,
                    decoration: InputDecoration(
                      hintText: 'Enter detailed description',
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
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.onTapSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Batalkan",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
