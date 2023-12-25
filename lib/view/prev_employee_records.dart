import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/view/current_attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';

class PrevRecordsEmployee extends StatelessWidget {
  const PrevRecordsEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Previous Records"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: HttpRequests().getHoursWorkedInDateRange(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.body.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => MontlyViewOfAttendance(
                            month: snapshot.data!.body[index]["month"],
                          ),
                        );
                      },
                      title: Text(snapshot.data!.body[index]["month"]),
                      leading: const Icon(Icons.calendar_today),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      subtitle: Text(
                          'Worked ${snapshot.data!.body[index]["hour"].toString()} hrs / ${snapshot.data!.body[index]["total"].toString()} entries'),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class MontlyViewOfAttendance extends StatelessWidget {
  const MontlyViewOfAttendance({Key? key, required this.month})
      : super(key: key);
  final String month;

  String convertToDateTime(String date, String enddate) {
    DateTime dateTime = DateTime.parse(date);
    DateTime endDateTime = DateTime.parse(enddate);
    return 'On ${DateFormat('d MMM').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)} to ${DateFormat('h:mm a').format(endDateTime)}';
  }

  String convertToDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(month),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: HttpRequests().getMonthWiseData(
            month: month,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.body.length == 0) {
                return const Center(
                  child: Text("No data found"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.body.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.body[index]["timestamp_end"] == null) {
                    return Card(
                      child: ListTile(
                        tileColor: (index == snapshot.data!.body.length - 1 &&
                                snapshot.data!.body[index]["timestamp_end"] ==
                                    null)
                            ? Colors.green[200]
                            : Colors.red[100],
                        onTap: () {
                          Get.to(
                            () => CurrentAttendance(
                              attendanceID: snapshot.data!.body[index]["id"],
                            ),
                          );
                        },
                        title: Text(
                            '${convertToDate(snapshot.data!.body[index]["timestamp_start"])} - Session ID ${snapshot.data!.body[index]["id"]}'),
                        leading: const Icon(Icons.calendar_today),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        subtitle: Text(
                            '${snapshot.data!.body[index]["timestamp_start"]} - Present'),
                      ),
                    );
                  }
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => CurrentAttendance(
                            attendanceID: snapshot.data!.body[index]["id"],
                          ),
                        );
                      },
                      title: Text(
                          '${convertToDate(snapshot.data!.body[index]["timestamp_start"])} - Session ID ${snapshot.data!.body[index]["id"]}'),
                      leading: const Icon(Icons.calendar_today),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      subtitle: Text(
                        convertToDateTime(
                            snapshot.data!.body[index]["timestamp_start"],
                            snapshot.data!.body[index]["timestamp_end"]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
