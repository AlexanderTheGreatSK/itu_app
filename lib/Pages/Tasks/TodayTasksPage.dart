import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/Tasks/TaskDetails.dart';

import '../../Database/DataClasses/Task.dart';

class TodayTasksPage extends StatefulWidget {
  const TodayTasksPage({super.key});

  @override
  State<TodayTasksPage> createState() => _TodayTasksPage();
}

class _TodayTasksPage extends State<TodayTasksPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: databaseHandler.getTaskForUser(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return taskWidget(tasks[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget taskWidget(Task task) {
    MaterialColor colorPriority;

    if(task.priority == 3) {
      colorPriority = Colors.red;
    } else if(task.priority == 2) {
      colorPriority = Colors.orange;
    } else {
      colorPriority = Colors.yellow;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: AlignmentDirectional.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              elevation: 15.0,
              child: Container(
                height: 75,
                color: colorPriority,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
                );
              },
              child: Container(
                height: 70,
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(task.name),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Every ${task.days} days", style: const TextStyle(color: Colors.grey),),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Material(
                                elevation: 10.0,
                                child: Container(
                                  color: Colors.deepPurple[300],
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    child: Text("🏆 ${task.reward}", style: const TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Material(
          elevation: 15.0,
          child: Container(
            color: Colors.grey[200],
            height: 70,
          ),
        ),
      ),
    );
  }

}