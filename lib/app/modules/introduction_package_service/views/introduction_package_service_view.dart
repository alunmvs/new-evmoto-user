import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/introduction_package_service_controller.dart';

class IntroductionPackageServiceView
    extends GetView<IntroductionPackageServiceController> {
  const IntroductionPackageServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntroductionPackageServiceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'IntroductionPackageServiceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
