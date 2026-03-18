import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class RideOrderChatAndCallDriverSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderChatAndCallDriverSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 46,
          child: OutlinedButton(
            onPressed: () async {
              Get.toNamed(
                Routes.RIDE_CALL_SENDBIRD,
                arguments: {
                  'is_caller': true,
                  'driver_id': controller.orderRideDetail.value.driverId,
                  'driver_name': controller.orderRideDetail.value.driverName,
                  'driver_avatar_url':
                      controller.orderRideDetail.value.driverAvatar,
                },
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: controller.themeColorServices.primaryBlue.value,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_phone.svg",
                        width: 11.18,
                        height: 12,
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  controller.languageServices.language.value.telephone ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: LoaderElevatedButton(
            onPressed: () async {
              Get.toNamed(
                Routes.RIDE_CHAT_SENDBIRD,
                arguments: {
                  "driver_id": controller.orderRideDetail.value.driverId,
                  "driver_name": controller.orderRideDetail.value.driverName,
                  "driver_avatar_url":
                      controller.orderRideDetail.value.driverAvatar,
                  "order_id": controller.orderRideDetail.value.orderId,
                  "order_type": controller.orderRideDetail.value.orderType,
                  "state": controller.orderRideDetail.value.state,
                  "driver_license_plate":
                      controller.orderRideDetail.value.licensePlate,
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.languageServices.language.value.chatDriver ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(color: Colors.white),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Color(0XFF16CB8C),
                  radius: 10 / 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
