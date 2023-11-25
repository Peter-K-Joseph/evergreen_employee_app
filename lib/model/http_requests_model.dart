import 'dart:convert';

import 'package:http/http.dart';

class HTTPResponseBody {
  final dynamic body;
  final int statusCode;

  HTTPResponseBody(this.body, this.statusCode);

  factory HTTPResponseBody.import(Response res, {bool isJson = true}) {
    return HTTPResponseBody(json.decode(res.body), res.statusCode);
  }

  Map<String, dynamic> toJson() => {
        "body": body,
        "statusCode": statusCode,
      };
}
