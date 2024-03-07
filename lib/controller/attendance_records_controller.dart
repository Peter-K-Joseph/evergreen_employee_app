import 'dart:io';

import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/attendance_model.dart';
import 'package:get/get.dart';

class AttendanceRecordsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    HttpRequests().getRecentEmployeeAttendanceRecords().then((value) => {});
  }

  Future<List<AttendanceRecordViewModel>> getAttendanceRecords() async {
    final response = await HttpRequests().getRecentEmployeeAttendanceRecords();
    if (response.statusCode == 200) {
      final List<AttendanceRecordViewModel> attendanceRecords = [];
      for (var record in response.body) {
        try {
          attendanceRecords.add(AttendanceRecordViewModel.fromJson(record));
        } catch (e) {
          print(e);
        }
      }
      return attendanceRecords;
    } else {
      Get.snackbar(
        'Error',
        'Failed to fetch attendance records',
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    }
  }
}
