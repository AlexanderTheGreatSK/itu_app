//Authors: Alexander Okrucký (xokruc00)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

import '../Database/DataClasses/Task.dart';
import '../Pages/Tasks/TaskDetails.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({super.key, required this.task, required this.update});
  final Task task;
  ValueNotifier<bool> update;

  @override
  TaskWidgetState createState() => TaskWidgetState();
}

class TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    MaterialColor colorPriority;
    DatabaseHandler databaseHandler = DatabaseHandler();

    if(widget.task.priority == 3) {
      colorPriority = Colors.red;
    } else if(widget.task.priority == 2) {
      colorPriority = Colors.orange;
    } else {
      colorPriority = Colors.green;
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
                  MaterialPageRoute(builder: (context) => TaskDetailsPage(task: widget.task)),
                ).then((value) {
                  widget.update.value = !widget.update.value;
                });
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
                          child: Text(widget.task.name),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Every ${widget.task.days} days", style: const TextStyle(color: Colors.grey),),
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
                            onTap: () {
                              databaseHandler.taskIsDone(widget.task);
                              widget.update.value = !widget.update.value;
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Material(
                                elevation: 10.0,
                                child: Container(
                                  color: Colors.deepPurple[300],
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    child: Text("🏆 ${widget.task.reward}", style: const TextStyle(color: Colors.white),),
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
  }

}