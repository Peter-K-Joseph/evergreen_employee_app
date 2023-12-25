import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/view/user_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AdminControls extends StatelessWidget {
  final DashboardController parentController;
  const AdminControls({Key? key, required this.parentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 130,
            ),
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
                              "100",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total Employees",
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
                              "Worked this month",
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
                    height: 30,
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
                              "Mismatched Records",
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
                              "0.00 Rs",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Paid this month",
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
              height: 30,
            ),
            ListTile(
              onTap: () {
                Get.to(
                  () => const UserManagement(),
                  transition: Transition.rightToLeft,
                );
              },
              title: const Text(
                "Modify Employee Records",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Add, remove or modify employee records",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.group_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Financial Records",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "View and modify financial records",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.monetization_on_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Attendance Records",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "View and modify attendance records",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Attendance Stats",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "View attendance statistics and reports",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.local_activity_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Get alerts and notifications regarding attendance",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Account Settings",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Change your account settings",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
