import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ActivityCardOriginDestinationSubView extends GetView<ActivityController> {
  final String startAddress;
  final String endAddress;
  const ActivityCardOriginDestinationSubView({
    super.key,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Timeline.tileBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        builder: TimelineTileBuilder(
          contentsAlign: ContentsAlign.basic,
          nodePositionBuilder: (context, index) {
            return 0;
          },
          indicatorPositionBuilder: (context, index) {
            return 0;
          },
          startConnectorBuilder: (context, index) {
            if (index != 0) {
              return DashedLineConnector(
                color:
                    controller.themeColorServices.neutralsColorSlate400.value,
              );
            }
            return null;
          },
          endConnectorBuilder: (context, index) {
            if (index != 1) {
              return DashedLineConnector(
                color:
                    controller.themeColorServices.neutralsColorSlate400.value,
              );
            }
            return null;
          },
          indicatorBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                width: 16,
                height: 16,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/icon_pinpoint_green.svg",
                    width: 11,
                    height: 14.14,
                  ),
                ),
              );
            }

            return SizedBox(
              width: 16,
              height: 16,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/icon_pinpoint_red.svg",
                  width: 11,
                  height: 14.14,
                ),
              ),
            );
          },
          contentsBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: index != 1 ? 10 : 0,
              top: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0) ...[
                  Text(
                    startAddress,
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (index == 1) ...[
                  Text(
                    endAddress,
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey700
                              .value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          itemCount: 2,
        ),
      ),
    );
  }
}
