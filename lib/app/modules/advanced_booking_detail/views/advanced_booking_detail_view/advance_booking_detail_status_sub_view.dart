import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/constants/advanced_booking_state_const.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';

class AdvanceBookingDetailStatusSubView
    extends GetView<AdvancedBookingDetailController> {
  const AdvanceBookingDetailStatusSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ([
            AdvancedBookingState.PENDING,
            AdvancedBookingState.DISTRIBUTING,
            AdvancedBookingState.DRIVER_FOUND,
          ].contains(controller.advancedBooking.value.state)) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFFFFF3E6),
                border: Border.all(color: Color(0XFFFFDDB9)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/icon_advance_booking_status_waiting_driver.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Sedang Menunggu Driver",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Color(0XFFEA7405)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if ([
                AdvancedBookingState.ONGOING,
              ].contains(controller.advancedBooking.value.state) &&
              [
                OrderState.DRIVER_PICK_UP_PASSENGER,
                OrderState.DRIVER_ARRIVED_ORIGIN,
              ].contains(
                controller.advancedBooking.value.spawnedOrderState,
              )) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFFEFF8FF),
                border: Border.all(color: Color(0XFFB3D9F8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/icon_advance_booking_status_ongoing_origin.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Driver Menuju Titik Jemput",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Color(0XFF0060C6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if ([
                AdvancedBookingState.ONGOING,
              ].contains(controller.advancedBooking.value.state) &&
              [
                OrderState.DRIVER_ON_GOING_DESTINATION,
                OrderState.DRIVER_ARRIVED_DESTINATION,
                OrderState.DRIVER_SEND_INVOICE,
              ].contains(
                controller.advancedBooking.value.spawnedOrderState,
              )) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFFEFF8FF),
                border: Border.all(color: Color(0XFFB3D9F8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/icon_advance_booking_status_ongoing_destination.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Driver Sedang Mengantar",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Color(0XFF0060C6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if ([
            AdvancedBookingState.CANCELLED,
          ].contains(controller.advancedBooking.value.state)) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFFFEEAEA),
                border: Border.all(color: Color(0XFFFFAEAE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/icon_advance_booking_status_cancel.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Pesanan Telah Dibatalkan",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Color(0XFFF22626)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if ([
            AdvancedBookingState.EXPIRED,
          ].contains(controller.advancedBooking.value.state)) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0XFFF4F4F4),
                border: Border.all(color: Color(0XFFD8D8D8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/icons/icon_advance_booking_status_expired.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Tidak Ada Driver Tersedia",
                      style: controller.typographyServices.bodyLargeBold.value
                          .copyWith(color: Color(0XFF6D6D6D)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
