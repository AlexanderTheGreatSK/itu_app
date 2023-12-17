import 'package:flutter/material.dart';

import '../../Database/DataClasses/Task.dart';
import '../../Database/DatabaseHandler.dart';
import '../../Widgets/TaskWidget.dart';

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
      body:
        ValueListenableBuilder<bool>(
        valueListenable: update,
        builder: (context, value, child) {
          return FutureBuilder(
            future: databaseHandler.getTaskForUserWeek(),
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
        }),

    );
  }
}