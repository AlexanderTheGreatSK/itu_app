import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/Tasks/TaskDetails.dart';

import '../../Database/DataClasses/Task.dart';
import '../../Widgets/TaskWidget.dart';

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
      body: ValueListenableBuilder<bool>(
        valueListenable: update,
        builder: (context, value, child) {
          return FutureBuilder(
            future: databaseHandler.getTaskForUserToday(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<Task> tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskWidget(task: tasks[index], update: update);
                  },
                );
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