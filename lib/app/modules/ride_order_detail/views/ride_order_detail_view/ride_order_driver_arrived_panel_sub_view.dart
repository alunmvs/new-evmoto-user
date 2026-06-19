import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_chat_and_call_driver_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_driver_information_card_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_help_contact_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_id_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_origin_and_destination_sub_view.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view/ride_order_payment_method_sub_view.dart';
import 'package:new_evmoto_user/app/utils/general_helper.dart';
import 'package:new_evmoto_user/app/utils/maps_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RideOrderDriverArrivedPanelSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderDriverArrivedPanelSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 262 + 132,
      maxHeight: MediaQuery.of(context).size.height * (528 / 812),
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
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 14,
                                child: Marquee(
                                  text:
                                      (controller
                                                  .languageServices
                                                  .language
                                                  .value
                                                  .arrived ??
                                              "-")
                                          .replaceFirst(
                                            "x",
                                            formatDoubleToString(
                                              double.parse(
                                                controller
                                                        .socketDriverPositionData
                                                        .value
                                                        .laveMileage ??
                                                    "0.0",
                                              ),
                                            ),
                                          )
                                          .replaceFirst(
                                            "x",
                                            getEstimatedTimeInMinutesInText(
                                              estimatedTimeInMinutes: double.parse(
                                                controller
                                                        .socketDriverPositionData
                                                        .value
                                                        .laveTime ??
                                                    "0.0",
                                              ),
                                            ),
                                          ),
                                  // '${formatDoubleToString(controller.estimatedDistanceInKm.value)} ${controller.languageServices.language.value.km} ·󠁏󠁏 ${getEstimatedTimeInMinutesInText(estimatedTimeInMinutes: controller.estimatedTimeInMinutes.value)} ${(controller.languageServices.language.value.arrived ?? "-")}'
                                  //     .toLowerCase(),
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                  blankSpace: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              controller.getEstimatedHourMinuteArrive(),
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
