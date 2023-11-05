import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

const List<String> list = <String>['Living Room', 'Bedroom', 'Kitchen', 'Garden'];

class AddNewRoom extends StatefulWidget {
  const AddNewRoom({super.key});

  @override
  State<AddNewRoom> createState() => AddNewRoomState();
}

class AddNewRoomState extends State<AddNewRoom> {
  TextEditingController textEditingController = TextEditingController();
  DatabaseHandler databaseHandler = DatabaseHandler();


  void create() {
    databaseHandler.addNewRoom(textEditingController.text).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Create new room"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a room name',
              ),
              cursorColor: Colors.deepPurpleAccent,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: SizedBox(
                height: 60,
                width: 200,
                child: DropdownButtonExample()),
          ),
          MaterialButton(
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              onPressed: create,
              child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 10,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}