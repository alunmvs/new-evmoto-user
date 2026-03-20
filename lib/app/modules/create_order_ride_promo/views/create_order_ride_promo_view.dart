import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_order_ride_promo_controller.dart';

class CreateOrderRidePromoView extends GetView<CreateOrderRidePromoController> {
  const CreateOrderRidePromoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateOrderRidePromoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateOrderRidePromoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
