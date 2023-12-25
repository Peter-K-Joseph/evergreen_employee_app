import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/controller/people_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactDirectory extends StatelessWidget {
  final DashboardController parentController;
  const ContactDirectory({Key? key, required this.parentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Obx(() => Get.find<PeopleController>().current.value),
      ),
    );
  }
}
