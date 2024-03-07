import 'package:evergreen_employee_app/controller/attendance_controller.dart';
import 'package:evergreen_employee_app/controller/dashboard_controller.dart';
import 'package:evergreen_employee_app/view/prev_employee_records.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Attendance extends StatelessWidget {
  final DashboardController parentController;
  final bool addPadding;
  final bool getAsScaffold;

  const Attendance({
    Key? key,
    required this.parentController,
    this.addPadding = true,
    this.getAsScaffold = false,
  }) : super(key: key);

  Widget getAttendanceWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          Get.find<AttendanceController>().getAttendance();
          Get.find<AttendanceController>().getCurrentPosition();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (addPadding)
                const SizedBox(
                  height: 130,
                ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                  future: Get.find<AttendanceController>().getAttendance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Obx(
                        () => Get.find<AttendanceController>()
                            .attendanceStatus
                            .value,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width - 40,
                      height: 300,
                      child: FutureBuilder(
                        future: Get.find<AttendanceController>()
                            .getCurrentPosition(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return FlutterMap(
                              options: const MapOptions(
                                initialCenter: LatLng(0, 0),
                                initialZoom: 15,
                              ),
                              mapController: Get.find<AttendanceController>()
                                  .mapController,
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.nuvie.employeeassist',
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Getting your location..."),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Text(
                        Get.find<AttendanceController>().location.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Get.find<AttendanceController>().getCurrentPosition();
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '*this location is used to mark your attendance',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      "Additional Controls",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(
                                () => const PrevRecordsEmployee(),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xff261132),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              foregroundColor: const Color(0xff261132),
                              backgroundColor: const Color(0xffB5F8FE),
                            ),
                            child: const Text(
                              'Prev. Records',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xff261132),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              foregroundColor: const Color(0xff261132),
                              backgroundColor: const Color(0xffEEFCCE),
                            ),
                            child: const Text(
                              'Work Hours',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getAsScaffold
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'Attendance',
              ),
            ),
            body: getAttendanceWidget(context),
          )
        : getAttendanceWidget(context);
  }
}
