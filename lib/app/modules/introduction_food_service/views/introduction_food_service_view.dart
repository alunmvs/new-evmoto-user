import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/introduction_food_service_controller.dart';

class IntroductionFoodServiceView
    extends GetView<IntroductionFoodServiceController> {
  const IntroductionFoodServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntroductionFoodServiceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'IntroductionFoodServiceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
