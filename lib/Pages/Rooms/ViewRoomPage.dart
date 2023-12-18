///Author: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Widgets/TaskWidget.dart';

import '../../Database/DataClasses/Room.dart';
import '../../Database/DataClasses/Task.dart';
import '../../Database/ImageHandler.dart';


class ViewRoomPage extends StatefulWidget {
  ViewRoomPage({super.key, required this.room});

  Room room;
  
  @override
  State<ViewRoomPage> createState() => _ViewRoomPageState();
}

class _ViewRoomPageState extends State<ViewRoomPage> {
  ///View the selected room with room name, image,
  ///tasks and progress bar (based on the current tidiness of the room)
  ImageHandler imageHandler = ImageHandler();
  DatabaseHandler databaseHandler = DatabaseHandler();
  final ValueNotifier<bool> update = ValueNotifier<bool>(false);
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
          const Padding(
            padding: EdgeInsets.only(left: 13.0, top: 13.0),
            child: Text("To be done:", style: TextStyle(fontSize: 18)),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: update,
            builder: (context, value, child) {
              return FutureBuilder<List<Task>>(
                future: databaseHandler.getTasksForRoom(widget.room.name),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    List<Task> tasks = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(task: tasks[index], update: update);
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            }),
        ]
      ),
      bottomNavigationBar:ValueListenableBuilder<bool>(
          valueListenable: update,
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
              child: FutureBuilder(
                future: databaseHandler.updateRoomStatusBar(widget.room.name),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    if(snapshot.data! < 0.0) {
                      return const Text("No tasks.");
                    }
                    return FAProgressBar(
                      currentValue: snapshot.data!,
                      backgroundColor: getProgressBarBackgroundColor(snapshot.data!),
                      progressColor: getProgressBarColor(snapshot.data!),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }),
    );
  }

  ///Color of the progressBar based on the tidiness of the room value
  Color getProgressBarBackgroundColor(double numberino) {
    if(numberino <= 33) {
      return Colors.red[200]!;
    } else if(numberino <= 66) {
      return Colors.orange[200]!;
    } else {
      return Colors.green[200]!;
    }
  }

  MaterialColor getProgressBarColor(double numberino) {
    if(numberino <= 33) {
      return Colors.red;
    } else if(numberino <= 66) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Widget imageWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image.asset(imageHandler.getLocalRooms(widget.room.imageId))
      /*FutureBuilder(
        future: imageHandler.getRoomImage(widget.room.imageId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),*/
    );
  }

}