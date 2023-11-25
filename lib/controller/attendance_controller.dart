import 'dart:async';
import 'dart:convert';

import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:evergreen_employee_app/view/current_attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class AttendanceController extends GetxController {
  AttendanceHandlers handlers = AttendanceHandlers();
  MapTileLayerController mapTileLayerController = MapTileLayerController();
  RxList<double> currentLocation = [
    0.0,
    0.0,
  ].obs;
  Position? pos;
  RxString location = 'We are getting your location details...'.obs;
  Rx<Widget> attendanceStatus = const Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Icon(Icons.search_rounded, size: 100),
      Text(
        "Checking your attendance status",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  ).obs;

  Future getAttendance() async {
    HTTPResponseBody response = await HttpRequests().getAttendanceStatus();
    if (response.body['state'] == "completed") {
      attendanceStatus.value = Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "You have marked your attendance today",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => CurrentAttendance(
                      attendanceID: response.body['records']['id'],
                    ),
                  );
                },
                child: const Text("Show Status"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (pos == null) {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      const SnackBar(
                        content: Text('Please wait while we get your location'),
                      ),
                    );
                    return;
                  }
                  handlers.enableAttendance(pos!, location.value);
                },
                child: const Text("New Check In"),
              ),
            ],
          )
        ],
      );
    } else if (response.body['state'] == "absent") {
      attendanceStatus.value = Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.cancel_outlined,
            size: 100,
            color: Color(0xffF45866),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "You have not marked your attendance today",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: () async {
              await getCurrentPosition();
              if (pos == null) {
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait while we get your location'),
                  ),
                );
                return;
              }
              handlers.enableAttendance(pos!, location.value);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xff261132),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              foregroundColor: const Color(0xff261132),
              backgroundColor: const Color(0xffCBFF8C),
            ),
            child: const Text("Check In"),
          ),
        ],
      );
    } else if (response.body['state'] == "present") {
      attendanceStatus.value = Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: Color.fromARGB(255, 229, 206, 0),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Your attendance has started but not ended",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await getCurrentPosition();
                  if (pos == null) {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      const SnackBar(
                        content: Text('Please wait while we get your location'),
                      ),
                    );
                    return;
                  }
                  handlers.endAttendance(
                    pos!,
                    location.value,
                  );
                },
                child: const Text("Checkout Session"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (pos == null) {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      const SnackBar(
                        content: Text('Please wait while we get your location'),
                      ),
                    );
                    return;
                  }
                  Get.to(
                    () => CurrentAttendance(
                      attendanceID: response.body['records']['id'],
                    ),
                    transition: Transition.cupertino,
                  );
                },
                child: const Text("View Session"),
              ),
            ],
          )
        ],
      );
    }
    return response;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  updateLocationString(double lat, double long) async {
    try {
      location.value = 'We are getting your location details...';
      var data = await HttpRequests().getLocationString(lat, long);
      location.value = json.decode(data.body)['display_name'];
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not resolve location address',
          ),
        ),
      );
      location.value = '$lat, $long';
    }
  }

  Future<bool> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return false;
    location.value = 'We are getting your location details...';
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      currentLocation.value = [position.latitude, position.longitude];
      try {
        if (pos == position) return true;
        mapTileLayerController.pixelToLatLng(
          Offset(
            Get.width / 2,
            Get.height / 2,
          ),
        );
        mapTileLayerController.insertMarker(0);
        pos = position;
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              'Unknown error occurred',
            ),
          ),
        );
      }
      await updateLocationString(position.latitude, position.longitude);
      return position;
    });
    return true;
  }

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    getAttendance();
    getCurrentPosition();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getCurrentPosition();
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

class AttendanceHandlers {
  String parseDateTimeToString(DateTime time) {
    DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm:ss a');
    String formatted = formatter.format(time);
    return formatted;
  }

  void enableAttendance(Position pos, String location) async {
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Attendance Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                        initialLatLngBounds: MapLatLngBounds(
                          MapLatLng(pos.latitude, pos.longitude),
                          MapLatLng(pos.latitude, pos.longitude),
                        ),
                        markerBuilder: (context, index) {
                          return MapMarker(
                            latitude: pos.latitude,
                            longitude: pos.longitude,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Check in time",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      parseDateTimeToString(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Check in location",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      location,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await HttpRequests()
                      .startAttendance(pos, location)
                      .then((value) {
                    if (value.statusCode == 200) {
                      Get.back();
                      Get.find<AttendanceController>().onInit();
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text(value.body['message']),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text(value.body['message']),
                        ),
                      );
                    }
                  });
                },
                child: const Text("Check in"),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  void endAttendance(Position pos, String location) {
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 800,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Attendance Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                        initialLatLngBounds: MapLatLngBounds(
                          MapLatLng(pos.latitude, pos.longitude),
                          MapLatLng(pos.latitude, pos.longitude),
                        ),
                        markerBuilder: (context, index) {
                          return MapMarker(
                            latitude: pos.latitude,
                            longitude: pos.longitude,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Check out time",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      parseDateTimeToString(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Check out location",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      location,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await HttpRequests()
                      .endAttendance(pos, location)
                      .then((value) {
                    if (value.statusCode == 200) {
                      Get.back();
                      Get.find<AttendanceController>().onInit();
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text(value.body['message']),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text(value.body['message']),
                        ),
                      );
                    }
                  });
                },
                child: const Text("Check out"),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
