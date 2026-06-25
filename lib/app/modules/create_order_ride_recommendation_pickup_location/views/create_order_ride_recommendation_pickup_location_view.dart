import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_order_ride_recommendation_pickup_location_controller.dart';

class CreateOrderRideRecommendationPickupLocationView
    extends GetView<CreateOrderRideRecommendationPickupLocationController> {
  const CreateOrderRideRecommendationPickupLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateOrderRideRecommendationPickupLocationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateOrderRideRecommendationPickupLocationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
