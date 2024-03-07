import 'dart:ffi';
import 'dart:io';

import 'package:evergreen_employee_app/controller/attendance_controller.dart';
import 'package:evergreen_employee_app/controller/attendance_stats_controller.dart';
import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AttendanceStats extends StatelessWidget {
  const AttendanceStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Stats',
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Active Employees",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3A405A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: Column(
                          children: [
                            Text(
                              "2.4 Hrs",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Worked hours",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3A405A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Entries",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3A405A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        child: Column(
                          children: [
                            Text(
                              "5.4 Hours / Day",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Average Time Spent",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3A405A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text(
                'Analytics - Individual',
              ),
              leading: const Icon(Icons.person),
              subtitle: const Text(
                'View individual employee attendance stats',
              ),
              onTap: () {
                Get.to(
                  () => const AttendanceStatsIndividual(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
            ListTile(
              title: const Text(
                'Analytics - Global',
              ),
              leading: const Icon(Icons.group),
              subtitle: const Text(
                'View overall employee attendance stats',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceStatsIndividual extends StatelessWidget {
  const AttendanceStatsIndividual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Individual Attendance Stats',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: FutureBuilder(
                  future: HttpRequests().getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: ListView.builder(
                          itemCount: snapshot.data.body.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () => Get.to(
                                  () => AttendanceDateWiseStats(),
                                  transition: Transition.rightToLeft,
                                  binding: BindingsBuilder(() {
                                Get.put<AttendanceDayWiseController>(
                                  AttendanceDayWiseController(
                                    snapshot.data.body[index]['employee_id'],
                                  ),
                                );
                              })),
                              title: Text(
                                snapshot.data.body[index]['name'],
                              ),
                              subtitle: Text(
                                snapshot.data.body[index]['employee_id'],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceDateWiseStats extends StatelessWidget {
  const AttendanceDateWiseStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Date Wise Attendance Stats',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => Get.find<AttendanceDayWiseController>().statsBoard.value,
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Get.find<AttendanceDayWiseController>().statsWidget.value,
              )
            ],
          ),
        ),
      ),
    );
  }
}
