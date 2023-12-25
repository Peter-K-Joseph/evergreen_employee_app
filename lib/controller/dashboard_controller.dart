import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt activeNotifications = 3.obs;
  RxInt currentIndex = 0.obs;
  RxString title = "".obs;
  Rx<Color> appBarColor = const Color.fromARGB(91, 0, 91, 238).obs;
  Rx<Color> iconColor = Colors.white.obs;

  changeAppBarColor() {
    switch (currentIndex.value) {
      case 0:
        appBarColor.value = const Color.fromARGB(91, 0, 91, 238);
        iconColor.value = Colors.white;
        title.value = "";
        break;
      case 1:
        appBarColor.value = const Color.fromARGB(91, 255, 255, 255);
        iconColor.value = Colors.black;
        title.value = "Attendance";
        break;
      case 2:
        appBarColor.value = const Color.fromARGB(91, 255, 255, 255);
        iconColor.value = Colors.black;
        title.value = "Employee Contacts";
        break;
      case 3:
        appBarColor.value = const Color.fromARGB(91, 255, 255, 255);
        iconColor.value = Colors.black;
        title.value = "Payments";
        break;
      case 4:
        appBarColor.value = const Color.fromARGB(91, 255, 255, 255);
        iconColor.value = Colors.black;
        title.value = "Admin Controls";
        break;
      default:
        appBarColor.value = const Color.fromARGB(91, 255, 255, 255);
        iconColor.value = Colors.black;
    }
  }
}
