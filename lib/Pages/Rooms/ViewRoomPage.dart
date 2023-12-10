import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Widgets/TaskWidget.dart';

import '../../Database/DataClasses/Room.dart';
import '../../Database/DataClasses/Task.dart';
import '../../Database/ImageHandler.dart';

class ViewRoomPage extends StatefulWidget {
  const ViewRoomPage({super.key, required this.room});

  final Room room;
  
  @override
  State<ViewRoomPage> createState() => _ViewRoomPageState();
}

class _ViewRoomPageState extends State<ViewRoomPage> {
  ImageHandler imageHandler = ImageHandler();
  DatabaseHandler databaseHandler = DatabaseHandler();

  int itemCnt = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: ListView(
        children: [
          imageWidget(),
          FutureBuilder<List<Task>>(
            future: databaseHandler.getTasksForRoom(widget.room.name),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<Task> tasks = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskWidget(task: tasks[index]);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ]
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
        child: FAProgressBar(
          currentValue: widget.room.progressBarValue.toDouble(),
          backgroundColor: getProgressBarBackgroundColor(),
          progressColor: getProgressBarColor(),
        ),
      ),
    );
  }

  Color getProgressBarBackgroundColor() {
    if(widget.room.progressBarValue <= 33) {
      return Colors.red[200]!;
    } else if(widget.room.progressBarValue <= 66) {
      return Colors.orange[200]!;
    } else {
      return Colors.green[200]!;
    }
  }

  MaterialColor getProgressBarColor() {
    if(widget.room.progressBarValue <= 33) {
      return Colors.red;
    } else if(widget.room.progressBarValue <= 66) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Widget imageWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image.asset(imageHandler.getLocalImage(widget.room.imageId)),
    );
  }

}