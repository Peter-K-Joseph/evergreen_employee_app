import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCreationController extends GetxController {
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final photoUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // void createUser() {
  //   if (formKey.currentState!.validate()) {
  //     HttpRequests().createUser(
  //       nameController.text,
  //       departmentController.text,
  //       photoUrlController.text,
  //     );
  //   }
  // }

  Future<List> getDepartments() async {
    final response = await HttpRequests().getDepartments();
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return [];
    }
  }
}
