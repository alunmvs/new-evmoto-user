import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_saved_location_controller.dart';

class SettingSavedLocationView extends GetView<SettingSavedLocationController> {
  const SettingSavedLocationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingSavedLocationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingSavedLocationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
