//Authors: Alexander Okrucký (xokruc00)


import 'package:flutter/material.dart';

import '../../Database/DataClasses/Task.dart';
import '../../Database/DatabaseHandler.dart';
import '../../Widgets/TaskWidget.dart';
import 'CreateTaskPage.dart';

class WeekTasksPage extends StatefulWidget {
  const WeekTasksPage({super.key});

  @override
  State<WeekTasksPage> createState() => _WeekTasksPage();
}

class _WeekTasksPage extends State<WeekTasksPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  final ValueNotifier<bool> update = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          tooltip: "Create new task",
          enableFeedback: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCreateTaskPage()),
            ).then((value) {
              update.value = !update.value;
            });
          },
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.add_task, color: Colors.white),
        ),
      ),
      body:
        ValueListenableBuilder<bool>(
        valueListenable: update,
        builder: (context, value, child) {
          return FutureBuilder(
            future: databaseHandler.getTaskForUserWeek(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<Task> tasks = snapshot.data!;
                if(tasks.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text("This week is done 😎", style: TextStyle(fontSize: 30))),
                      Center(child: Text("what about to sneak peak to calendar 😶‍🌫️", style: TextStyle(fontSize: 18))),
                      Center(child: Text("to be prepared for next week 🤓", style: TextStyle(fontSize: 18))),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskWidget(task: tasks[index], update: update);
                    },
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }),

    );
  }
}