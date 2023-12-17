import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/FrequencyUnits.dart';
import 'package:itu_app/Widgets/UserChooser.dart';
import 'package:shimmer/shimmer.dart';
import 'package:itu_app/Database/DataClasses/Task.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../Database/DataClasses/Room.dart';
import '../../Database/DatabaseHandler.dart';

enum InputError {none, name, room, lastDone, frequency, frequencyUnits, users}

class MyCreateTaskPage extends StatefulWidget {
  const MyCreateTaskPage({super.key});

  @override
  State<MyCreateTaskPage> createState() => _MyCreateTaskPageState();
}

class _MyCreateTaskPageState extends State<MyCreateTaskPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  int chosenID = 0;
  UserChooserController userChooserController = UserChooserController();
  double currentSliderValue = 5;
  List<DropdownMenuEntry<String>> entries = [];
  String chosenRoom = "";
  String chosenFrequencyUnit = "";
  bool loadingRooms = true;
  DateTime lastDoneDate = DateTime.now();
  String formatedLastDoneDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
  List<DropdownMenuEntry<String>> frequencyEntries = [
    const DropdownMenuEntry(value: "1", label: "Day"),
    const DropdownMenuEntry(value: "7", label: "Week"),
    const DropdownMenuEntry(value: "31", label: "Month"),
    const DropdownMenuEntry(value: "365", label: "Year"),
  ];
  double currentPriorityValue = 1;
  List<bool> checked = [];
  List<String> usersIds = [];
  List<OurUser> users = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  void crateNewTask() {
    print(chosenFrequencyUnit);
    if(nameController.text != "" && chosenRoom != "" && daysController.text != "" && chosenFrequencyUnit != "" && users.isNotEmpty) {
      int days = int.parse(daysController.text) * int.parse(chosenFrequencyUnit);
      DateTime next = lastDoneDate.add(Duration(days: days));

      int between = daysBetween(DateTime.now(), next);
      bool done = false;
      if(between > 3) {
        done = true;
      }

      Task newTask = Task(nameController.text, currentSliderValue.round(), int.parse(daysController.text), currentPriorityValue.round(), done,
          chosenRoom, lastDoneDate, next, userChooserController.getUserIds());

      databaseHandler.createTask(newTask);
      Navigator.pop(context);
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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
      label: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text("Assigned room"),
      ),
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
                    showNavigationArrow: true,
                    todayHighlightColor: Colors.deepPurple[400],
                    selectionColor: Colors.deepPurple[400],
                    onSelectionChanged: onSelectionDateChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: TextField(
                        controller: daysController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Frequency",
                            labelStyle: TextStyle(color: Colors.deepPurple[400]),
                            fillColor: Colors.grey[300],
                            filled: true,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                      ),
                    ),
                  ),
                ),
                //const Spacer(),
                Flexible(
                  flex: 2,
                  child: DropdownMenu<String>(
                    expandedInsets: const EdgeInsets.only(right: 10),
                    label: const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text("Frequency units"),
                    ),
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
                    dropdownMenuEntries: frequencyEntries,
                    onSelected: (String? value) {
                      setState(() {
                        chosenFrequencyUnit = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Choose priority:", style: TextStyle(fontSize: 20.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(["Low", "Medium", "High"][currentPriorityValue.round()],
                      style: TextStyle(fontSize: 20.0, color: [Colors.green, Colors.orange, Colors.red][currentPriorityValue.round()])),
                ),
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
                          value: currentPriorityValue,
                          min: 0,
                          max: 2,
                          divisions: 2,
                          label: ["Low", "Medium", "High"][currentPriorityValue.round()],
                          onChanged: (double value) {
                            setState(() {
                              currentPriorityValue = value;
                            });
                          },
                        ),
                      ),
                    ],
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
                          min: 0,
                          max: 9,
                          divisions: 9,
                          label: (currentSliderValue.round()+1).toString(),
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
                          Text("${(currentSliderValue.round()+1).toString()} 🏆", style: const TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: (usersIds.isEmpty) ? FutureBuilder(
                future: databaseHandler.getUsers(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    users = snapshot.data!;
                    return UserChooser(
                        users: users,
                        controller: userChooserController,
                        //checked: checked,
                        //usersIds: usersIds
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ) : UserChooser(
                  users: users,
                  controller: userChooserController,
                  //checked: checked,
                  //usersIds: usersIds
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Material(
                  elevation: 10.0,
                  child: InkWell(
                    onTap: crateNewTask,
                    child: Container(
                      height: 50,
                      color: Colors.deepPurple,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("CREATE", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}