import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/controllers/ride_order_cancel_controller.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RideOrderCancelReasonListSubView
    extends GetView<RideOrderCancelController> {
  const RideOrderCancelReasonListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller
                    .languageServices
                    .language
                    .value
                    .cancelOrderConfirmationDescription ??
                "-",
            style: controller.typographyServices.bodySmallRegular.value
                .copyWith(
                  color: controller.themeColorServices.primaryBlue.value,
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
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value:
                "I don't need car for the time being due to a change in intinerary",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason1 ??
                  "-",
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
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value:
                "In a hurry, I need to change use other means of transportation",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason2 ??
                  "-",
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
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "The vehicle dispatched by the platform is too far",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason3 ??
                  "-",
              style: controller.typographyServices.bodySmallBold.value,
            ),
          ),
          ReactiveRadioListTile<String>(
            formControlName: 'reason',
            contentPadding: EdgeInsets.all(0),
            fillColor: WidgetStatePropertyAll(
              controller.reason.value ==
                      "The driver didn't come pick me up for various reasons"
                  ? controller.themeColorServices.primaryBlue.value
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "The driver didn't come pick me up for various reasons",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason4 ??
                  "-",
              style: controller.typographyServices.bodySmallBold.value,
            ),
          ),
          ReactiveRadioListTile<String>(
            formControlName: 'reason',
            contentPadding: EdgeInsets.all(0),
            fillColor: WidgetStatePropertyAll(
              controller.reason.value == "Can't contact the driver"
                  ? controller.themeColorServices.primaryBlue.value
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "Can't contact the driver",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason5 ??
                  "-",
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
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "Driver asks for fare increase or transact by cash",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason6 ??
                  "-",
              style: controller.typographyServices.bodySmallBold.value,
            ),
          ),
          ReactiveRadioListTile<String>(
            formControlName: 'reason',
            contentPadding: EdgeInsets.all(0),
            fillColor: WidgetStatePropertyAll(
              controller.reason.value == "Driver is late"
                  ? controller.themeColorServices.primaryBlue.value
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "Driver is late",
            title: Text(
              controller.languageServices.language.value.cancelOrderReason7 ??
                  "-",
              style: controller.typographyServices.bodySmallBold.value,
            ),
          ),
          ReactiveRadioListTile<String>(
            formControlName: 'reason',
            contentPadding: EdgeInsets.all(0),
            fillColor: WidgetStatePropertyAll(
              controller.reason.value == "Other"
                  ? controller.themeColorServices.primaryBlue.value
                  : controller.themeColorServices.neutralsColorGrey400.value,
            ),
            onChanged: (control) {
              controller.reason.value = control.value!;
            },
            value: "Other",
            title: Text(
              controller
                      .languageServices
                      .language
                      .value
                      .cancelOrderReasonOther ??
                  "-",
              style: controller.typographyServices.bodySmallBold.value,
            ),
          ),
        ],
      ),
    );
  }
}
