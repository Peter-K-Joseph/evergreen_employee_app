import 'package:evergreen_employee_app/controller/attendance_controller.dart';
import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/controller/home_controller.dart';
import 'package:evergreen_employee_app/controller/people_controller.dart';
import 'package:get/get.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<AttendanceController>(AttendanceController(), permanent: true);
    Get.put<PeopleController>(PeopleController(), permanent: true);
  }
}
