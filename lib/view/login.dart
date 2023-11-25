import 'package:evergreen_employee_app/controller/login_controller.dart';
import 'package:evergreen_employee_app/mischelaneous/bindings.dart';
import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/mischelaneous/overlays.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:evergreen_employee_app/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController _controller = LoginController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginPage({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 30,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login to\nEmployee Assist",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            hintText: "2062209",
                            labelText: "Employee ID",
                            floatingLabelStyle:
                                TextStyle(color: Colors.grey.shade800),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade500,
                                width: 1.5,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          controller: _controller.employeeIdController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => Column(
                            children: [
                              TextFormField(
                                autofillHints: const [
                                  AutofillHints.password,
                                ],
                                obscureText:
                                    _controller.getPasswordVisibilityStatus(),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  floatingLabelStyle: TextStyle(
                                    color: _controller
                                            .getPasswordVisibilityStatus()
                                        ? Colors.grey.shade800
                                        : const Color(0XFF265be9),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: _controller
                                              .getPasswordVisibilityStatus()
                                          ? Colors.grey.shade500
                                          : const Color(0XFF265be9),
                                      width: 1.5,
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: _controller
                                              .getPasswordVisibilityStatus()
                                          ? Colors.grey.shade300
                                          : const Color(0XFF265be9),
                                    ),
                                  ),
                                  hintText: "**********",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _controller.togglePasswordVisibility();
                                    },
                                    icon: Icon(
                                      _controller.getPasswordVisibilityStatus()
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                controller: _controller.passwordController,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?"),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              showDialog(
                                context: Get.context!,
                                builder: (context) =>
                                    OverlayScreens().loading(context),
                              );
                              HTTPResponseBody status =
                                  await HttpRequests().login(
                                employeeId:
                                    _controller.employeeIdController.text,
                                password: _controller.passwordController.text,
                              );
                              if (status.statusCode == 200) {
                                Get.offAll(
                                  () => Dashboard(),
                                  binding: DashboardBindings(),
                                  transition: Transition.cupertino,
                                );
                              } else {
                                Get.back();
                                Get.snackbar(
                                  "Error",
                                  "${status.body["detail"]["message"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0XFF265be9),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: <Widget>[
                      Expanded(child: Divider()),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Connected to Evergreen PV"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
