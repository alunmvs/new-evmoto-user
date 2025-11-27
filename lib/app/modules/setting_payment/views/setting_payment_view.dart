import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_payment_controller.dart';

class SettingPaymentView extends GetView<SettingPaymentController> {
  const SettingPaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingPaymentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingPaymentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
