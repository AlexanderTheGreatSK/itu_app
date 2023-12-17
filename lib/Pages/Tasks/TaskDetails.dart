//Authors: Alexander Okrucký (xokruc00)

import 'package:flutter/material.dart';

import '../../Database/DataClasses/Task.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetailsPage> createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        title: const Text("Task details", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(widget.task.name, style: const TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("🏆 ${widget.task.reward}", style: const TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Days of repeat: ${widget.task.days}", style: const TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Assigned to: ${widget.task.room}", style: const TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Assigned to: ${widget.task.lastDone}", style: const TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Assigned to: ${widget.task.targetDate}", style: const TextStyle(fontSize: 25.0)),
            ),
          ],
        ),
      ),
    );
  }

}