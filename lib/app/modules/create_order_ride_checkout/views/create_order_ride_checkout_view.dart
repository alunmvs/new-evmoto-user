import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
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
                  child: Animarker(
                    mapId: controller.googleMapController.future.then<int>(
                      (value) => value.mapId,
                    ),
                    markers: Set<Marker>.from(controller.markers.values),
                    shouldAnimateCamera: false,
                    duration: const Duration(milliseconds: 2400),
                    curve: Curves.linear,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      indoorViewEnabled: false,
                      initialCameraPosition:
                          controller.initialCameraPosition.value,
                      polylines: controller.polylines,
                      onMapCreated:
                          (GoogleMapController googleMapController) async {
                            controller.googleMapController.complete(
                              googleMapController,
                            );

                            controller.isFetch.value = true;
                            try {
                              await controller.getOrderRidePricingList();
                              if (controller.isClosed) return;

                              await controller.getAvailableCouponList();
                              if (controller.isClosed) return;

                              await Future.wait([
                                controller.generatePolylinesOpenMapsApi(),
                                controller.refocusMapsBound(),
                                controller.getOrderRidePricingList(),
                                controller.setLatitudeLongitudeMarker(),
                                controller.refreshMarkerDriverNearby(),
                              ]);
                              if (controller.isClosed) return;

                              controller.enableDriverNearbyTimer();
                            } on DioException catch (e) {
                              if (!controller.isClosed) {
                                SnackbarHelper.showSnackbarError(
                                  text: e.error.toString(),
                                );
                              }
                            } catch (e) {
                              if (!controller.isClosed) {
                                SnackbarHelper.showSnackbarError(
                                  text: e.toString(),
                                );
                              }
                            }
                            if (!controller.isClosed) {
                              controller.isFetch.value = false;
                            }
                          },
                    ),
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
