import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Database/DataClasses/Task.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/BEtestPages/CreateRoomPage.dart';

import 'BEtestPages/CreateTaskPage.dart';

class MyBEtestPage extends StatefulWidget {
  const MyBEtestPage({super.key});

  @override
  State<MyBEtestPage> createState() => _MyBEtestPageState();
}

class _MyBEtestPageState extends State<MyBEtestPage> {

  DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> getShoppingLists() async {
    List<ShoppingList> shoppingLists = await databaseHandler.getShoppingLists();
    int index = 0;
    for(ShoppingList shoppingList in shoppingLists) {
      print("ShoppingList $index ----------");
      shoppingList.debugPrint();
      index++;
    }
  }

  Future<void> getAllUsers() async {
    List<OurUser> users = await databaseHandler.getUsers();
    int index = 0;
    for(OurUser user in users) {
      print("User $index ----------");
      user.debugPrint();
      index++;
    }
  }

  Future<void> getTasksForWC() async {
    List<Task> wcTasks = await databaseHandler.getTasksForRoom("WC");
    int index = 0;
    for(var task in wcTasks) {
      print("Task $index ----------");
      task.debugPrint();
      index++;
    }
  }

  Future<void> getTasksForAlex() async {
    List<Task> alexTasks = await databaseHandler.getTaskForUser("ApWjem5KL7OekZhSToV1rBv99My1");
    int index = 0;
    for(var task in alexTasks) {
      print("Task $index ----------");
      task.debugPrint();
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BE tester"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: getShoppingLists,
            child: const Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("getShoppingLists()"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          InkWell(
            onTap: getAllUsers,
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("getAllUsers()"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCreateRoomPage()),
              );
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("createRoom()"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCreateTaskPage()),
              );
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("createTask()"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          InkWell(
            onTap: getTasksForWC,
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("getTasksForRoom(WC)"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          InkWell(
            onTap: getTasksForAlex,
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("getTasksForUser(Alex)"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
        ],
      ),
    );
  }

}