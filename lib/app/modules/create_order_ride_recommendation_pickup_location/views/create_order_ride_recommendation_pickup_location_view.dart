import 'package:flutter/material.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_recommendation_pickup_location/views/create_order_ride_recommendation_pickup_location_view/recommendation_pickup_location_footer_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_recommendation_pickup_location/views/create_order_ride_recommendation_pickup_location_view/recommendation_pickup_location_header_sub_view.dart';

import '../controllers/create_order_ride_recommendation_pickup_location_controller.dart';

class CreateOrderRideRecommendationPickupLocationView
    extends GetView<CreateOrderRideRecommendationPickupLocationController> {
  const CreateOrderRideRecommendationPickupLocationView({super.key});

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
                      onMapCreated:
                          (GoogleMapController googleMapController) async {
                            controller.googleMapController.complete(
                              googleMapController,
                            );
                            await controller.onMapCreated();
                          },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (150 / 812),
                ),
              ],
            ),
            RecommendationPickupLocationHeaderSubView(),
            RecommendationPickupLocationFooterSubView(),
            if (controller.isFetch.value == true) ...[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                ),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
