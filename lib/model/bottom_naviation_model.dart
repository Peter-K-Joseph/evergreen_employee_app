import 'package:flutter/material.dart';

// create a view for bottom navigation bar
class BottomNavigationModel {
  List<BottomNavigationBarItem> items = [];

  BottomNavigationModel() {
    items = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Attendance",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined),
        label: "People",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.payment_outlined),
        label: "Payments",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings_outlined),
        label: "Admin",
      ),
    ];
  }
}
