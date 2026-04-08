import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_header_sub_view.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import '../controllers/create_order_ride_checkout_controller.dart';

class CreateOrderRideCheckoutView
    extends GetView<CreateOrderRideCheckoutController> {
  const CreateOrderRideCheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        controller.initialCameraPosition.value,
                    markers: controller.markers,
                    polylines: controller.polylines,
                    onMapCreated:
                        (GoogleMapController googleMapController) async {
                          controller.googleMapController = googleMapController;

                          controller.isFetch.value = true;
                          try {
                            await controller.getAvailableCouponList();

                            await Future.wait([
                              controller.generatePolylinesOpenMapsApi(),
                              controller.refocusMapsBound(),
                              controller.getOrderRidePricingList(),
                              controller.setLatitudeLongitudeMarker(),
                            ]);
                          } on DioException catch (e) {
                            Get.back();

                            SnackbarHelper.showSnackbarError(
                              text: e.error.toString(),
                            );
                          } catch (e) {
                            SnackbarHelper.showSnackbarError(
                              text: e.toString(),
                            );
                          }
                          controller.isFetch.value = false;
                        },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (150 / 812),
                ),
              ],
            ),
            CheckoutHeaderSubView(),
            CheckoutFooterSubView(),
          ],
        ),
      ),
    );
  }
}
