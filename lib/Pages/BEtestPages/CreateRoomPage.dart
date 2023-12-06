import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/Room.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyCreateRoomPage extends StatefulWidget {
  const MyCreateRoomPage({super.key});

  @override
  State<MyCreateRoomPage> createState() => _MyCreateRoomPageState();
}

class _MyCreateRoomPageState extends State<MyCreateRoomPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController progressBarController = TextEditingController();

  void crateNewRoom() {
    Room room = Room(nameController.text, imageController.text, int.parse(progressBarController.text, radix: 10));

    databaseHandler.createRoom(room).onError((error, stackTrace) {
      print("ERROR OCCURED");
      print(error);
      print(stackTrace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new room"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name"
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: imageController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "ImageId"
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: progressBarController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "StatusBarNumber"
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MaterialButton(
              onPressed: crateNewRoom,
              color: Colors.lightGreenAccent,
              child: const Text("Create"),
            ),
          ),
        ],
      ),
    );
  }

}