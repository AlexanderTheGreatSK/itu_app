import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/Task.dart';
import 'package:itu_app/Database/DataClasses/User.dart';

import '../../Database/DatabaseHandler.dart';

class MyCreateTaskPage extends StatefulWidget {
  const MyCreateTaskPage({super.key});

  @override
  State<MyCreateTaskPage> createState() => _MyCreateTaskPageState();
}

class _MyCreateTaskPageState extends State<MyCreateTaskPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  String chosenID = "";

  /// PLS do not be lazy as me and use FormTextField -> one controller for group of TextFields :))
  TextEditingController nameController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController lastDoneController = TextEditingController();
  TextEditingController targetDateController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController rewardController = TextEditingController();
  TextEditingController taskIsDoneController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  Future<void> crateNewTask() async {
    List<String> users = [];
    users.add(chosenID);

    Task newTask = Task(nameController.text, int.parse(rewardController.text), int.parse(daysController.text), int.parse(priorityController.text), bool.parse(taskIsDoneController.text),
        roomController.text, DateTime.parse(lastDoneController.text), DateTime.parse(targetDateController.text), users);

    await databaseHandler.createTask(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new task"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: daysController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Days"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: lastDoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "LastDoneDate"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: targetDateController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "TargetDate"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: priorityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Priority"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: rewardController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Reward"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: taskIsDoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "TaskIsDone"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: roomController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Room"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Alex"),
                        value: "ApWjem5KL7OekZhSToV1rBv99My1",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Džejn"),
                        value: "4ZmwxEOSUBSXKnfiCzGmH8EaP1Z2",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Elinka"),
                        value: "QYxII6KeZYNGBsAtEWVsKy57X2B3",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: crateNewTask,
                color: Colors.lightGreenAccent,
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}