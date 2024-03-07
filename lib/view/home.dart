import 'dart:math';

import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/controller/home_controller.dart';
import 'package:evergreen_employee_app/mischelaneous/overlays.dart';
import 'package:evergreen_employee_app/view/attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final DashboardController parentController;
  Home({Key? key, required this.parentController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xff005cee),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 140,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              '${Get.find<HomeController>().greetings.value},',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              Get.find<HomeController>().name.value,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      Obx(
                        () => Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: randomColorGenerator(),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Get.find<HomeController>().imageURL.value !=
                                    ''
                                ? Image.network(
                                    Get.find<HomeController>().imageURL.value,
                                    fit: BoxFit.contain,
                                  )
                                : Center(
                                    child: Text(
                                      Get.find<HomeController>().name.value[0],
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Attendance Summary",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => Scaffold(
                              appBar: AppBar(
                                title: const Text("Manage Attendance"),
                              ),
                              body: Attendance(
                                parentController: parentController,
                                addPadding: false,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.view_agenda_outlined),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Get.find<HomeController>().currentAttendance.value,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Active Employees",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.assignment_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Column(
                  children: [
                    Text(
                      "Response Code: 403: You do not have the necessary permission to access this resource",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
