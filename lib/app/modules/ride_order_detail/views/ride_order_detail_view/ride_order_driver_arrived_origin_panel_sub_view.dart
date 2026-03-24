import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_chat_and_call_driver_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_driver_information_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_help_contact_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_id_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_origin_and_destination_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_payment_method_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../routes/app_pages.dart';

class RideOrderDriverArrivedOriginPanelSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderDriverArrivedOriginPanelSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 262 + 132,
      maxHeight: MediaQuery.of(context).size.height * 0.7561,
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      color: Colors.transparent,
      boxShadow: [],
      panelBuilder: (sc) {
        return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RideOrderHelpContactSubView(),
              SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: Offset(0, -1),
                      ),
                    ],
                    color: Color(0XFFCEE2F8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.5],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .driverArriveThePickupPoint ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Container(
                                      width: 33,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey300
                                            .value,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: sc,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child:
                                            RideOrderDriverInformationCardSubView(),
                                      ),
                                      SizedBox(height: 16),
                                      DashedLine(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey300
                                            .value,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                          top: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                        child:
                                            RideOrderChatAndCallDriverSubView(),
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child:
                                            RideOrderOriginAndDestinationSubView(),
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: RideOrderPaymentMethodSubView(),
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: RideOrderIdSubView(),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
