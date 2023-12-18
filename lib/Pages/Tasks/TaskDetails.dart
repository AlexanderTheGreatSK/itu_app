//Authors: Alexander Okrucký (xokruc00)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
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

    String lastDate = DateFormat('dd.MM.yyyy').format(widget.task.lastDone);
    String targetDate = DateFormat('dd.MM.yyyy').format(widget.task.targetDate);

    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            //
          },
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.edit, color: Colors.white,),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        title: const Text("Task details", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 100,
                  child: Icon(
                      Icons.add_task,
                      color: Colors.white,
                      size: 80,
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("\nName: ${widget.task.name}", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("Points: ${widget.task.reward} 🏆", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Priority: ", style: TextStyle(fontSize: 25.0)),
                    _buildPriorityDot(widget.task.priority),
                    const Text("\n", style: TextStyle(fontSize: 25.0)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("Days to repeat: ${widget.task.days}", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("Assigned room: ${widget.task.room}\n", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("🗓 Last done: $lastDate", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("🗓 Deadline: $targetDate", style: const TextStyle(fontSize: 25.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Material(
                    elevation: 10.0,
                    child: InkWell(
                      onTap: deleteTask,
                      child: Container(
                        height: 50,
                        color: Colors.red,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("DELETE", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DatabaseHandler databaseHandler = DatabaseHandler();
  void deleteTask() {
    databaseHandler.deleteTask(widget.task).then((_) {
      Navigator.of(context).pop();
    });
  }

  Widget _buildPriorityDot(int priority) {
    Color colorPriority;

    if(priority == 3) {
      colorPriority = Colors.red;
    } else if(priority == 2) {
      colorPriority = Colors.orange;
    } else {
      colorPriority = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorPriority,
      ),
    );
  }
}