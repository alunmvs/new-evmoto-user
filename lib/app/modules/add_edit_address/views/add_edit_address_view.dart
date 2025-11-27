import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_edit_address_controller.dart';

class AddEditAddressView extends GetView<AddEditAddressController> {
  const AddEditAddressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddEditAddressView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddEditAddressView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
