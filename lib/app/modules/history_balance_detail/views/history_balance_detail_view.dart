import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_balance_detail_controller.dart';

class HistoryBalanceDetailView extends GetView<HistoryBalanceDetailController> {
  const HistoryBalanceDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HistoryBalanceDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HistoryBalanceDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
