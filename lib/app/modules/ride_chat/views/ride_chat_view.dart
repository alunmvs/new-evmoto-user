import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ride_chat_controller.dart';

class RideChatView extends GetView<RideChatController> {
  const RideChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('RideChatView'), centerTitle: true),
        body: const Center(
          child: Text(
            'RideChatView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
