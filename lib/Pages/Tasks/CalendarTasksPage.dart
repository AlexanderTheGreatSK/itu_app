import 'package:flutter/material.dart';

class CalendarTasksPage extends StatefulWidget {
  const CalendarTasksPage({super.key});

  @override
  State<CalendarTasksPage> createState() => _WeekTasksPage();
}

class _WeekTasksPage extends State<CalendarTasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Calendar")),
    );
  }
}