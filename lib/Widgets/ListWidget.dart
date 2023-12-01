import 'package:flutter/material.dart';

class OurWidgets {
  Widget listWidget(String name, String item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const Icon(
            Icons.ac_unit,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }
}