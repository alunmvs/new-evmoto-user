import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/views/ride_order_done_view/ride_order_done_driver_information_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/views/ride_order_done_view/ride_order_done_invoice_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/ride_order_done_controller.dart';

class RideOrderDoneView extends GetView<RideOrderDoneController> {
  const RideOrderDoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.orderCompleted ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RideOrderDoneDriverInformationCardSubView(),
                      SizedBox(height: 12),
                      Container(
                        height: 33,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorSlate100
                              .value,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            controller.orderRideDetail.value.orderNum
                                .toString(),
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      RideOrderDoneInvoiceSubView(),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
        // bottomNavigationBar: controller.isFetch.value
        //     ? null
        //     : BottomAppBar(
        //         height: 78,
        //         color: controller.themeColorServices.neutralsColorGrey0.value,
        //         shadowColor: controller.themeColorServices.overlayDark100.value
        //             .withValues(alpha: 0.1),
        //         child: Column(
        //           children: [
        //             LoaderElevatedButton(
        //               onPressed: controller.showIHavePaidButton.value == false
        //                   ? null
        //                   : () async {
        //                       await controller.onTapDone();
        //                     },
        //               child: Text(
        //                 controller.showIHavePaidButton.value == false
        //                     ? (controller
        //                               .languageServices
        //                               .language
        //                               .value
        //                               .waitingDriverConfirmation ??
        //                           "-")
        //                     : (controller
        //                               .languageServices
        //                               .language
        //                               .value
        //                               .paymentConfirmation ??
        //                           "-"),
        //                 style: controller.typographyServices.bodyLargeBold.value
        //                     .copyWith(color: Colors.white),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
      ),
    );
  }
}
