import 'dart:math';

import 'package:flutter/material.dart';

class OverlayScreens {
  Widget loading(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget signingIn(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              Center(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color randomColorGenerator() {
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    const Color.fromARGB(255, 232, 102, 255),
    Colors.orange,
    const Color.fromARGB(255, 255, 113, 160),
    Colors.teal,
    const Color.fromARGB(255, 255, 177, 149),
    const Color.fromARGB(255, 109, 131, 255),
  ];
  // geberate radom number
  int randomNumber = Random().nextInt(colors.length);
  return colors[randomNumber];
}
