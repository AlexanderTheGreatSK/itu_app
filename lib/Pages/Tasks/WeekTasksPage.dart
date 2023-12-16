import 'package:flutter/material.dart';

class WeekTasksPage extends StatefulWidget {
  const WeekTasksPage({super.key});

  @override
  State<WeekTasksPage> createState() => _WeekTasksPage();
}

class _WeekTasksPage extends State<WeekTasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Week")),
    );
  }
}