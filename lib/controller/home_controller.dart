import 'dart:async';
import 'dart:io';

import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/mischelaneous/database.dart';
import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:evergreen_employee_app/view/attendance.dart';
import 'package:evergreen_employee_app/view/current_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxString greetings = "Hello".obs;
  RxString name = "...".obs;
  Rx<Widget> currentAttendance = Container(
    width: MediaQuery.of(Get.context!).size.width,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xff3A405A),
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Preparing to fetch attendance",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Fetching data from Evergreen Services",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    ),
  ).obs;
  RxString imageURL = ''.obs;

  void generateGreetings() {
    var hour = DateTime.now().hour;
    var day = DateTime.now().weekday;
    if (hour < 12) {
      greetings.value = "Good Morning";
    } else if (hour < 17) {
      greetings.value = "Good Afternoon";
    } else {
      greetings.value = "Good Evening";
    }
    if (day == DateTime.sunday) {
      greetings.value = "Happy Sunday";
    }
  }

  void updateUserInformation() async {
    var name = await DatabaseStore().getEmployee();
    this.name.value = name[0]["name"];
    if (name[0]["photo_url"] == null) {
      imageURL.value = '';
    } else {
      imageURL.value = name[0]["photo_url"];
    }
  }

  String StringtoDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return (DateFormat('d MMM - hh:mm a').format(dateTime));
  }

  updateCurrentAttendance() async {
    // get the current attendance status and update the widget
    HTTPResponseBody responseBody = await HttpRequests().getAttendanceStatus();
    if (responseBody.body["state"] == "present") {
      currentAttendance.value = Container(
        width: MediaQuery.of(Get.context!).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF0F3BD),
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            Get.to(
              () => CurrentAttendance(
                attendanceID: responseBody.body["records"]["id"],
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Colors.black,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Session Started",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${StringtoDateTime(responseBody.body["records"]["timestamp_start"])}. Tap to view",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (responseBody.body["state"] == "completed") {
      currentAttendance.value = Container(
        width: MediaQuery.of(Get.context!).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xff9EE493),
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            Get.to(
              () => CurrentAttendance(
                attendanceID: responseBody.body["records"]["id"],
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Colors.black,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Session Ended",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${StringtoDateTime(responseBody.body["records"]["timestamp_start"])}. Tap to view",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else if (responseBody.body["state"] == "absent") {
      currentAttendance.value = Container(
        width: MediaQuery.of(Get.context!).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffD62839),
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            Get.to(
              () => Attendance(
                parentController: Get.find<DashboardController>(),
                addPadding: false,
                getAsScaffold: true,
              ),
            );
          },
          child: const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Session Found",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tap to go to attendance",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      currentAttendance.value = Container(
        width: MediaQuery.of(Get.context!).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffD62839),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Connection Failed",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Connection to Evergreen Services Failed",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  Timer? t;

  @override
  void onInit() {
    super.onInit();
    generateGreetings();
    updateUserInformation();
    Future.delayed(const Duration(seconds: 1), () {
      updateCurrentAttendance();
    });
    t = Timer.periodic(const Duration(seconds: 4), (timer) async {
      updateCurrentAttendance();
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }
}
