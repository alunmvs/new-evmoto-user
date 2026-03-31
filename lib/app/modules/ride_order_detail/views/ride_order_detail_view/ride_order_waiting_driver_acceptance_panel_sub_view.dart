import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideOrderWaitingDriverAcceptancePanelSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderWaitingDriverAcceptancePanelSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 120,
      maxHeight: 190,
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
          color: controller.themeColorServices.overlayDark200.value.withValues(
            alpha: 0.3,
          ),
          blurRadius: 32,
          spreadRadius: -6,
          offset: Offset(0, -1),
        ),
      ],
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: controller.themeColorServices.neutralsColorGrey0.value,
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
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller
                          .languageServices
                          .language
                          .value
                          .evMotorcycleDriverSearch ??
                      "-",
                  style: controller.typographyServices.bodyLargeBold.value,
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(999),
                  minHeight: 8,
                  color: controller.themeColorServices.primaryBlue.value,
                  backgroundColor:
                      controller.themeColorServices.neutralsColorGrey200.value,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async {
                  await controller.onTapOrderRideCancelBeforeDriver();
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    controller.themeColorServices.sematicColorRed400.value
                        .withValues(alpha: 0.1),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  controller.languageServices.language.value.cancel ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .sematicColorRed500
                            .value,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
