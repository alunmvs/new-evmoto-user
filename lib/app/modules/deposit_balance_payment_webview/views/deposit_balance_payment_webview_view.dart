import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewView
    extends GetView<DepositBalancePaymentWebviewController> {
  const DepositBalancePaymentWebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepositBalancePaymentWebviewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DepositBalancePaymentWebviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
