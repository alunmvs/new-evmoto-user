import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';

class RideOrderOriginAndDestinationSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderOriginAndDestinationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: controller.themeColorServices.neutralsColorGrey200.value,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_pinpoint_green.svg",
                        width: 13.33,
                        height: 13.33,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    controller.orderRideDetail.value.startAddress ?? "-",
                    style: controller.typographyServices.captionLargeBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          DashedLine(
            color: controller.themeColorServices.neutralsColorGrey200.value,
            dashSpace: 2,
            dashWidth: 2,
          ),
          Container(
            padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_pinpoint_red.svg",
                        width: 13.33,
                        height: 13.33,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    controller.orderRideDetail.value.endAddress ?? "-",
                    style: controller.typographyServices.captionLargeBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
