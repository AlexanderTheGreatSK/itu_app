import 'package:flutter/material.dart';

class OurWidgets {
  Widget roomWidget(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 10, right: 100, bottom: 10.0),
      child: Material(
        elevation: 20,
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(name, style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}