import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:itu_app/Database/DataClasses/Task.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../Database/DataClasses/Room.dart';
import '../../Database/DatabaseHandler.dart';

class MyCreateTaskPage extends StatefulWidget {
  const MyCreateTaskPage({super.key});

  @override
  State<MyCreateTaskPage> createState() => _MyCreateTaskPageState();
}

class _MyCreateTaskPageState extends State<MyCreateTaskPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  String chosenID = "";
  double currentSliderValue = 5;
  List<DropdownMenuEntry<String>> entries = [];
  String chosenRoom = "";
  bool loadingRooms = true;
  DateTime lastDoneDate = DateTime.now();
  String formatedLastDoneDate = DateFormat('dd.MM.yyyy').format(DateTime.now());

  /// PLS do not be lazy as me and use FormTextField -> one controller for group of TextFields :))
  TextEditingController nameController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController lastDoneController = TextEditingController();
  TextEditingController targetDateController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController rewardController = TextEditingController();
  TextEditingController taskIsDoneController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  Future<void> crateNewTask() async {
    List<String> users = [];
    users.add(chosenID);

    Task newTask = Task(nameController.text, int.parse(rewardController.text), int.parse(daysController.text), int.parse(priorityController.text), bool.parse(taskIsDoneController.text),
        roomController.text, DateTime.parse(lastDoneController.text), DateTime.parse(targetDateController.text), users);

    await databaseHandler.createTask(newTask);
  }

  Widget buildEffect(BuildContext context) {
    return Shimmer.fromColors(
      enabled: loadingRooms,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: roomPickerWidget(context),
    );
  }

  Widget roomPickerWidget(BuildContext context) {
    return DropdownMenu<String>(
      label: const Text("Assigned room"),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[300],
        labelStyle: TextStyle(color: Colors.deepPurple[400]),
        alignLabelWithHint: true
      ),
      trailingIcon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple[400]),
      expandedInsets: const EdgeInsets.only(left: 10.0, right: 10.0),
      enabled: !loadingRooms,
      dropdownMenuEntries: entries,
      onSelected: (String? value) {
        setState(() {
          chosenRoom = value!;
          print(chosenRoom);
        });
      },
    );
  }

  Future<void> getRooms() async {
    await Future.delayed(const Duration(seconds: 2));
    List<Room> rooms = await databaseHandler.getRooms();
    entries = rooms.map<DropdownMenuEntry<String>>((Room room) {
      return DropdownMenuEntry(value: room.name, label: room.name);
    }).toList();
    
    setState(() {
      loadingRooms = false;
    });
  }

  void onSelectionDateChanged(DateRangePickerSelectionChangedArgs arguments) {
    print(arguments.value);
    setState(() {
      lastDoneDate = arguments.value;
      formatedLastDoneDate = DateFormat('dd.MM.yyyy').format(arguments.value);
    });
  }

  @override
  void initState() {
    getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new task"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.deepPurple[400]),
                      fillColor: Colors.grey[300],
                      filled: true
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
              child: (loadingRooms) ? buildEffect(context) : roomPickerWidget(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text("Last done date:", style: TextStyle(fontSize: 20),),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(formatedLastDoneDate, style: TextStyle(fontSize: 20, color: Colors.deepPurple[400])),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  //color: Colors.grey[300],
                  child: SfDateRangePicker(
                    todayHighlightColor: Colors.deepPurple[400],
                    selectionColor: Colors.deepPurple[400],
                    onSelectionChanged: onSelectionDateChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Choose reward:", style: TextStyle(fontSize: 20.0)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  //color: Colors.grey[300],
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Slider(
                          value: currentSliderValue,
                          min: 1,
                          max: 10,
                          divisions: 10,
                          label: currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              currentSliderValue = value;
                            });
                          },

                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${currentSliderValue.round().toString()} 🏆", style: const TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: daysController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Days"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: lastDoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "LastDoneDate"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: targetDateController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "TargetDate"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: priorityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Priority"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: rewardController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Reward"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: taskIsDoneController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "TaskIsDone"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: roomController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Room"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Alex"),
                        value: "ApWjem5KL7OekZhSToV1rBv99My1",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Džejn"),
                        value: "4ZmwxEOSUBSXKnfiCzGmH8EaP1Z2",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RadioListTile(
                        title: const Text("Elinka"),
                        value: "QYxII6KeZYNGBsAtEWVsKy57X2B3",
                        groupValue: chosenID,
                        onChanged: (newValue) {
                          setState(() {
                            chosenID = newValue.toString();
                          });
                        }),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: crateNewTask,
                color: Colors.lightGreenAccent,
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}