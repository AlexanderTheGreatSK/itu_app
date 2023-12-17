//Authors: Alexander Okrucký (xokruc00)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/Tasks/TaskDetails.dart';

import '../../Database/DataClasses/Task.dart';
import '../../Widgets/TaskWidget.dart';
import 'CreateTaskPage.dart';

class TodayTasksPage extends StatefulWidget {
  const TodayTasksPage({super.key});

  @override
  State<TodayTasksPage> createState() => _TodayTasksPage();
}

class _TodayTasksPage extends State<TodayTasksPage> {
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
            );
            update.value = !update.value;
          },
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.add_task, color: Colors.white),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: update,
        builder: (context, value, child) {
          return FutureBuilder(
            future: databaseHandler.getTaskForUserToday(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<Task> tasks = snapshot.data!;
                if(tasks.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text("Today no tasks 😎", style: TextStyle(fontSize: 30))),
                      Center(child: Text("maybe try to look at this week tasks 🤔", style: TextStyle(fontSize: 19))),
                      Center(child: Text("or just chill and enjoy life 🤗", style: TextStyle(fontSize: 19))),
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
        })
    );
  }
}