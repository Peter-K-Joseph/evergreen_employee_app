import 'package:evergreen_employee_app/controller/attendance_controller.dart';
import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
  }
}
