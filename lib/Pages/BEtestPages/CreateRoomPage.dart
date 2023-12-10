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

    Navigator.pop(context);

  }

  final FixedExtentScrollController controller = FixedExtentScrollController();

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
            child: Container(
              height: 400,
              //width: double.infinity,
              child: ListWheelScrollView(
                //scrollDirection: Axis.horizontal,
                controller: controller,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: MediaQuery.of(context).size.width,
                children: [
                  Image.asset("res/images/1.png"),
                  Image.asset("res/images/2.png"),
                  Image.asset("res/images/3.png"),
                  Image.asset("res/images/4.png"),
                  Image.asset("res/images/5.png"),
                  Image.asset("res/images/6.png"),
                  Image.asset("res/images/7.png"),
                  Image.asset("res/images/8.png"),
                  Image.asset("res/images/9.png"),
                  Image.asset("res/images/10.png"),
                  Image.asset("res/images/11.png"),
                  Image.asset("res/images/12.png"),
                  Image.asset("res/images/13.png"),
                  Image.asset("res/images/14.png"),
                  Image.asset("res/images/15.png"),
                ]
              ),
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
              color: Colors.deepPurple[300],
              textColor: Colors.white,
              child: const Text("Create"),
            ),
          ),
        ],
      ),
    );
  }

}