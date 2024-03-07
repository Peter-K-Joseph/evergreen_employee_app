import 'dart:convert';
import 'package:evergreen_employee_app/mischelaneous/constants.dart';
import 'package:evergreen_employee_app/mischelaneous/database.dart';
import 'package:evergreen_employee_app/model/http_requests_model.dart';
import 'package:evergreen_employee_app/model/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String token = '';

class HttpRequests {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<String> checkURLResponse(String url) async {
    if (!url.contains('http://') && !url.contains('https://')) {
      url = 'https://$url';
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return 'success';
      } else {
        String responseString;
        switch (response.statusCode) {
          case 404:
            responseString = 'Domain not found';
          case 500:
            responseString = 'Internal server error';
          case 403:
            responseString = 'Forbidden';
          case 401:
            responseString = 'Unauthorized';
          case 400:
            responseString = 'Bad request';
          case 408:
            responseString = 'Request timeout';
          case 409:
            responseString = 'Conflict';
          case 503:
            responseString = 'Service unavailable';
            break;
          default:
            responseString =
                'Something went wrong the URL. Server Responded with ${response.statusCode}';
            break;
        }
        return responseString;
      }
    } catch (e) {
      return 'Something went wrong with the URL. Please check the URL again';
    }
  }

  Future<HTTPResponseBody> login({
    required String employeeId,
    required String password,
  }) async {
    http.Response res = await http.post(
      Uri.parse('${Constants().backendUrl}/auth/login'),
      body: {
        'username': employeeId,
        'grant_type': "password",
        'password': password,
      },
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> temp = json.decode(res.body)["user"];
      DatabaseStore().addEmployeeData(
        UserModel(
          email: temp['email'],
          employeeId: employeeId,
          name: temp['name'],
          token: json.decode(res.body)["access_token"],
          isSigninedIn: true,
          photoUrl: temp['photoURL'],
        ),
      );
      token = json.decode(res.body)["access_token"];
    }
    return HTTPResponseBody.import(res);
  }

  // Contacts Endpoints
  Future<HTTPResponseBody> getDepartments() async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants().backendUrl}/apis/network/departments'),
        headers: headers,
      );
      return HTTPResponseBody.import(res);
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return HTTPResponseBody({
          'message': 'Please check your internet connection',
          'status': 500,
        }, 500);
      } else if (e.toString().contains('TimeoutException')) {
        return HTTPResponseBody({
          'message': 'Request timed out',
          'status': 500,
        }, 500);
      } else if (e.toString().contains('HandshakeException')) {
        return HTTPResponseBody({
          'message': 'Something went wrong. ${e.toString()}}',
          'status': 500,
        }, 500);
      } else if (e.toString().contains('HttpException')) {
        return HTTPResponseBody({
          'message': 'Something went wrong. ${e.toString()}}',
          'status': 500,
        }, 500);
      } else if (e.toString().contains('ClientException')) {
        return HTTPResponseBody({
          'message': 'Something went wrong. ${e.toString()}}',
          'status': 500,
        }, 500);
      } else {
        return HTTPResponseBody({
          'message': 'Something went wrong. ${e.toString()}}',
          'status': 500,
        }, 500);
      }
    }
  }

  initToken() {
    DatabaseStore().initializeLocalTokenFromDatabase().then((value) {
      if (value != null) {
        token = value;
      }
    });
  }

  getAttendanceStatus() async {
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants().backendUrl}/api/attendance/current'),
        headers: headers,
      );
      return HTTPResponseBody.import(res);
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return 'Please check your internet connection';
      } else if (e.toString().contains('TimeoutException')) {
        return 'Request timed out';
      } else if (e.toString().contains('HandshakeException')) {
        return 'Something went wrong. ${e.toString()}}';
      } else if (e.toString().contains('HttpException')) {
        return 'Something went wrong. ${e.toString()}}';
      } else if (e.toString().contains('ClientException')) {
        return 'Something went wrong. ${e.toString()}}';
      } else {
        return 'Something went wrong. ${e.toString()}}';
      }
    }
  }

  getLocationString(double latitude, double longitude) {
    return http.get(
      Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      ),
    );
  }

  Future<HTTPResponseBody> startAttendance(
      Position pos, String location) async {
    http.Response res = await http.post(
      Uri.parse('${Constants().backendUrl}/api/attendance/current'),
      headers: headers,
      body: json.encode({
        "location": '${pos.latitude},${pos.longitude}, $location',
      }),
    );
    return HTTPResponseBody.import(res);
  }

  endAttendance(Position pos, String location) {
    return http.put(
      Uri.parse('${Constants().backendUrl}/api/attendance/current'),
      headers: headers,
      body: json.encode({
        "location": '${pos.latitude},${pos.longitude}, $location',
      }),
    );
  }

  getAttendance(int attendanceID) async {
    http.Response res = await http.get(
      Uri.parse('${Constants().backendUrl}/api/attendance/id/$attendanceID'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getHoursWorkedInDateRange(
      {DateTime? startDate, DateTime? endDate}) async {
    String url = '';
    if (startDate == null || endDate == null) {
      url = '${Constants().backendUrl}/api/attendance/hours/montly';
    } else {
      url =
          '${Constants().backendUrl}/api/attendance/hours/montly?start_date=${startDate.toIso8601String()}&end_date=${endDate.toIso8601String()}';
    }
    http.Response res = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getMonthWiseData({required String month}) async {
    // convert March 2023 to Datetime for what comes in month var
    // get the employee id from the database
    // get the data from the backend
    var employeeId = await DatabaseStore().getEmployee();
    DateTime date = DateFormat('MMMM, yyyy').parse(month);
    DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);
    endOfMonth = endOfMonth.subtract(const Duration(days: 1));
    http.Response res = await http.get(
      Uri.parse(
          '${Constants().backendUrl}/api/attendance/${employeeId[0]['employee_id']}/${date.toIso8601String()}/${endOfMonth.toIso8601String()}'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getPeople(String department) async {
    http.Response res = await http.get(
      Uri.parse('${Constants().backendUrl}/apis/network/$department/members'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getEmployeeDetails(String memberID) async {
    http.Response res = await http.get(
      Uri.parse('${Constants().backendUrl}/apis/network/$memberID'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getUsers() async {
    http.Response res = await http.get(
      Uri.parse('${Constants().backendUrl}/apis/employee'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getRecentEmployeeAttendanceRecords() async {
    http.Response res = await http.get(
      Uri.parse('${Constants().backendUrl}/api/attendance/admin/recents'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }

  Future<HTTPResponseBody> getEmployeeAttendanceRecords(
      String employeeID) async {
    http.Response res = await http.get(
      Uri.parse(
          '${Constants().backendUrl}/api/reports/performance/$employeeID'),
      headers: headers,
    );
    return HTTPResponseBody.import(res);
  }
}
