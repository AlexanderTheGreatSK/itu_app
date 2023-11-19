import 'package:flutter/material.dart';

class MyRoomsPage extends StatefulWidget {
  const MyRoomsPage({super.key});

  @override
  State<MyRoomsPage> createState() => _MyRoomsPageState();
}

class _MyRoomsPageState extends State<MyRoomsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ROOMS"),
      ),
    );
  }
}