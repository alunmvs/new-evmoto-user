import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/voucher_detail_controller.dart';

class VoucherDetailView extends GetView<VoucherDetailController> {
  const VoucherDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VoucherDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VoucherDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
