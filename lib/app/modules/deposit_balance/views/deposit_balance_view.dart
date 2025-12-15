import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deposit_balance_controller.dart';

class DepositBalanceView extends GetView<DepositBalanceController> {
  const DepositBalanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepositBalanceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DepositBalanceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
