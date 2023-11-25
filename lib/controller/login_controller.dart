import 'package:evergreen_employee_app/mischelaneous/bindings.dart';
import 'package:evergreen_employee_app/mischelaneous/database.dart';
import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/mischelaneous/overlays.dart';
import 'package:evergreen_employee_app/model/login.dart';
import 'package:evergreen_employee_app/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginModel model = LoginModel();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    model.isPasswordVisible.value = !model.isPasswordVisible.value;
  }

  void autoLogin() async {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (context) => OverlayScreens().signingIn(context),
      );
    }
    DatabaseStore().getEmployee().then((value) async {
      if (value != null && value.length != 0) {
        await HttpRequests().initToken();
        Get.offAll(
          () => Dashboard(),
          binding: DashboardBindings(),
          transition: Transition.fadeIn,
        );
      } else {
        Get.back();
      }
    });
  }

  bool getPasswordVisibilityStatus() {
    return model.isPasswordVisible.value;
  }

  @override
  void onReady() {
    super.onReady();
    autoLogin();
  }
}
