import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/introduction_delivery_service_controller.dart';

class IntroductionDeliveryServiceView
    extends GetView<IntroductionDeliveryServiceController> {
  const IntroductionDeliveryServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntroductionDeliveryServiceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'IntroductionDeliveryServiceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
