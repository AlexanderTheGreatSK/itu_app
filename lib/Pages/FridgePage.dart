import 'package:flutter/material.dart';

class MyFridgePage extends StatefulWidget {
  const MyFridgePage({super.key});

  @override
  State<MyFridgePage> createState() => _MyFridgePageState();
}

class _MyFridgePageState extends State<MyFridgePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("FRIDGE"),
      ),
    );
  }
}