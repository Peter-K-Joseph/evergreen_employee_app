import 'package:get/get.dart';

class LoginModel {
  RxBool isPasswordVisible = true.obs;
}

class UserModel {
  String email;
  String employeeId;
  String name;
  String? token;
  bool? isSigninedIn = false;

  UserModel({
    required this.email,
    required this.employeeId,
    required this.name,
    this.token,
    this.isSigninedIn,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "employee_id": employeeId,
        "name": name,
        "token": token,
        "isSigninedIn": (isSigninedIn == null || !isSigninedIn!) ? 0 : 1,
      };
}
