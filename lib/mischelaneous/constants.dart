import 'package:flutter/material.dart';

class InputBorderDefinition {
  OutlineInputBorder errorBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
  );

  OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Colors.grey.shade500,
      width: 1.5,
    ),
  );

  OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Colors.grey.shade300,
      width: 1.5,
    ),
  );
}

class Constants {
  String backendUrl = "http://127.0.0.1:8000";
}
