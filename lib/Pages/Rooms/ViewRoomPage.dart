import 'package:flutter/material.dart';

import '../../Database/DataClasses/Room.dart';

class ViewRoomPage extends StatefulWidget {
  const ViewRoomPage({super.key, required this.room});

  final Room room;
  
  @override
  State<ViewRoomPage> createState() => _ViewRoomPageState();
}

class _ViewRoomPageState extends State<ViewRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(widget.room.name),
      ),
    );
    }
}