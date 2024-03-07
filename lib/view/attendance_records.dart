import 'package:evergreen_employee_app/controller/attendance_records_controller.dart';
import 'package:evergreen_employee_app/model/attendance_model.dart';
import 'package:evergreen_employee_app/view/current_attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceRecords extends StatelessWidget {
  const AttendanceRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Records',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Get.find<AttendanceRecordsController>()
                  .getAttendanceRecords(),
              builder: (context, snapshot) {
                print(snapshot.hasData);
                if (snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => {
                            Get.to(
                              () => CurrentAttendance(
                                attendanceID: snapshot.data![index].id,
                              ),
                            )
                          },
                          title: Text(
                            '${snapshot.data![index].name} (${snapshot.data![index].employeeId})',
                          ),
                          subtitle: Text(
                            '${DateFormat('dd/MM/yyyy').format(
                              snapshot.data![index].timestampStart,
                            )}, ${DateFormat('hh:mm a').format(
                              snapshot.data![index].timestampStart,
                            )} to ${DateFormat('hh:mm a').format(
                              snapshot.data![index].timestampEnd,
                            )}',
                          ),
                          leading: const Icon(
                            Icons.person,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
