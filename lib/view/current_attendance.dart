import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:evergreen_employee_app/view/alert_notify.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CurrentAttendance extends StatelessWidget {
  int attendanceID;
  MapTileLayerController controller = MapTileLayerController();

  CurrentAttendance({Key? key, required this.attendanceID}) : super(key: key);

  addMarkers(int addMarker) {
    for (int i = 0; i < addMarker; i++) {
      controller.insertMarker(i);
    }
  }

  String parseDateTimeToString(DateTime time) {
    DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm:ss a');
    String formatted = formatter.format(time);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Attendance"),
        centerTitle: true,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: HttpRequests().getAttendance(attendanceID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map body = (snapshot.data as HTTPResponseBody).body;
                if (body['state'] == "completed") {
                  List latLng =
                      body['records']['location_start'].split(',').map((e) {
                    return e;
                  }).toList();
                  List latLng2 =
                      body['records']['location_end'].split(',').map((e) {
                    return e;
                  }).toList();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    addMarkers(2);
                  });
                  return Column(
                    children: [
                      const AlertNotifier(
                          type: "success",
                          text: "Attendance Record is completed"),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Attendance ID",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  body['records']['id'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.grey.shade300,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Check In Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                              width: MediaQuery.of(context).size.width - 40,
                              height: 300,
                              child: SfMaps(
                                layers: [
                                  MapTileLayer(
                                      initialLatLngBounds: MapLatLngBounds(
                                        MapLatLng(
                                          double.parse(latLng[0]),
                                          double.parse(latLng[1]),
                                        ),
                                        MapLatLng(
                                          double.parse(latLng2[0]),
                                          double.parse(latLng2[1]),
                                        ),
                                      ),
                                      controller: controller,
                                      markerBuilder: (context, index) {
                                        return MapMarker(
                                          latitude: double.parse(latLng[0]),
                                          longitude: double.parse(latLng[1]),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                      initialZoomLevel: 15,
                                      initialFocalLatLng: const MapLatLng(0, 0),
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              parseDateTimeToString(
                                DateTime.parse(
                                  body['records']['timestamp_start'],
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
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
                            Text(
                              body['records']['location_start'],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.grey.shade300,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Check Out",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
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
                              width: MediaQuery.of(context).size.width - 40,
                              height: 300,
                              child: SfMaps(
                                layers: [
                                  MapTileLayer(
                                      initialLatLngBounds: MapLatLngBounds(
                                        MapLatLng(
                                          double.parse(latLng[0]),
                                          double.parse(latLng[1]),
                                        ),
                                        MapLatLng(
                                          double.parse(latLng2[0]),
                                          double.parse(latLng2[1]),
                                        ),
                                      ),
                                      controller: controller,
                                      markerBuilder: (context, index) {
                                        return MapMarker(
                                          latitude: double.parse(latLng2[0]),
                                          longitude: double.parse(latLng2[1]),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                      initialZoomLevel: 15,
                                      initialFocalLatLng: const MapLatLng(0, 0),
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              parseDateTimeToString(
                                DateTime.parse(
                                  body['records']['timestamp_end'],
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
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
                            Text(
                              body['records']['location_end'],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                } else if (body['state'] == "absent") {
                  return Column(
                    children: [
                      const AlertNotifier(
                          type: "error", text: "Attendance is absent"),
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
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xffE5625E),
                              size: 150,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Attendance record not found.",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Contact you IT Support Engineer.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (body['state'] == "present") {
                  List latLng =
                      body['records']['location_start'].split(',').map((e) {
                    return e;
                  }).toList();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    addMarkers(2);
                  });
                  return Column(
                    children: [
                      const AlertNotifier(
                        type: "warning",
                        text:
                            "Session is still running. This will not be counted as attendance till it ends.",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (DateTime.parse(
                            body['records']['timestamp_start'],
                          ).day !=
                          DateTime.now().day)
                        const AlertNotifier(
                          type: "error",
                          text:
                              "System mismatch detected! Contact your IT Adminstrator to end this session",
                        ),
                      if (DateTime.parse(
                            body['records']['timestamp_start'],
                          ).day !=
                          DateTime.now().day)
                        const SizedBox(
                          height: 15,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Attendance ID",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  body['records']['id'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width - 40,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Check In Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
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
                              width: MediaQuery.of(context).size.width - 40,
                              height: 300,
                              child: SfMaps(
                                layers: [
                                  MapTileLayer(
                                      initialLatLngBounds: MapLatLngBounds(
                                        MapLatLng(
                                          double.parse(latLng[0]),
                                          double.parse(latLng[1]),
                                        ),
                                        MapLatLng(
                                          double.parse(latLng[0]),
                                          double.parse(latLng[1]),
                                        ),
                                      ),
                                      controller: controller,
                                      markerBuilder: (context, index) {
                                        return MapMarker(
                                          latitude: double.parse(latLng[0]),
                                          longitude: double.parse(latLng[1]),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                      initialZoomLevel: 15,
                                      initialFocalLatLng: const MapLatLng(0, 0),
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              parseDateTimeToString(
                                DateTime.parse(
                                  body['records']['timestamp_start'],
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
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
                            Text(
                              body['records']['location_start'],
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                } else {
                  return Column(
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
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 40,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xffE5625E),
                              size: 150,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Attendance record corrupted or not found.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Contact your IT Support Engineer.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Colors.grey.shade300,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Debug Log",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Attendance ID",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  attendanceID.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Server Response",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (snapshot.data as HTTPResponseBody)
                                      .statusCode
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ((snapshot.data as HTTPResponseBody)
                                                .statusCode ==
                                            200)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Response Data",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  body.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
