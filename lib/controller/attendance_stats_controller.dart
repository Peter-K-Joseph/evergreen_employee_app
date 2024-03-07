import 'package:evergreen_employee_app/mischelaneous/http_requests.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendanceStatsController extends GetxController {}

class AttendanceDayWiseController extends GetxController {
  String id;
  Rx<Widget> statsBoard = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ).obs;

  Rx<Widget> statsWidget = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ).obs;

  AttendanceDayWiseController(this.id);

  groupedBarData(data) {
    List<LineChartBarData> res = [];
    int x = -1;
    int y = -1;
    int z = -1;
    int a = -1;
    List<int> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(data[i][2]);
    }
    res.addAll(
      {
        LineChartBarData(
          showingIndicators: spots,
          spots: generateFLPoint(data),
          color: Colors.red,
        ),
      },
    );

    return res;
  }

  List<FlSpot> generateFLPoint(gen) {
    List<FlSpot> spots = [];
    for (int i = 0; i < gen.length; i++) {
      spots.add(FlSpot(i.toDouble(), gen[i][2].toDouble()));
    }
    return spots;
  }

  findBarBottom(data) {
    List<String> date = [];
    for (int i = 0; i < data.length; i++) {
      if (i % 5 == 0) {
        date.add(data[i][0].split("-")[2]);
      } else {
        date.add("");
      }
    }
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (value, meta) {
        return Text(date[value.toInt()]);
      },
    );
  }

  loadWidgetGraph() async {
    HTTPResponseBody body =
        await HttpRequests().getEmployeeAttendanceRecords(id);
    List<dynamic> data = body.body;
    statsBoard.value = Container(
      width: MediaQuery.of(Get.context!).size.width,
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: groupedBarData(data),
          minY: 0,
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
              top: BorderSide(),
              right: BorderSide(),
            ),
          ),
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: findBarBottom(data),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );

    statsWidget.value = Container(
      width: MediaQuery.of(Get.context!).size.width - 20,
      margin: const EdgeInsets.all(10),
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(Get.context!).size.width / 2 - 30,
            child: Column(
              children: [
                Text(
                  data.length.toString(),
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
            width: MediaQuery.of(Get.context!).size.width / 2 - 30,
            child: Column(
              children: [
                Text(
                  data.map((e) => e[2]).reduce((a, b) => a + b).toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Minutes Worked",
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
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadWidgetGraph();
  }
}
