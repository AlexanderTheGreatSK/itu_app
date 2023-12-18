//Authors: Jana Kováčiková (xkovac59)


import 'package:flutter/material.dart';
import 'package:itu_app/Database/ImageHandler.dart';

import '../Database/DataClasses/Room.dart';
import '../Pages/Rooms/ViewRoomPage.dart';

class RoomWidget extends StatefulWidget {
  const RoomWidget({super.key, required this.room});
  final Room room;

  @override
  RoomWidgetState createState() => RoomWidgetState();
}

class RoomWidgetState extends State<RoomWidget> {
  ImageHandler imageHandler = ImageHandler();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewRoomPage(room: widget.room)));
      },
      child: FutureBuilder(
        future: imageHandler.getRoomImage(widget.room.imageId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      )

    );
  }

}