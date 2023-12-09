import 'package:flutter/material.dart';

class MyListContent extends StatelessWidget {
  const MyListContent({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 200,
        color: Colors.deepPurpleAccent,
      ),
    );
  }
}
