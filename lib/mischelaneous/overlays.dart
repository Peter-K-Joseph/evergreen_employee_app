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
