import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Database/DataClasses/Task.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Database/ImageHandler.dart';
import 'package:itu_app/Pages/BEtestPages/CreateRoomPage.dart';
import 'package:itu_app/Pages/BEtestPages/CreateShoppingList.dart';

import '../Database/DataClasses/Room.dart';
import 'Tasks/CreateTaskPage.dart';

class MyBEtestPage extends StatefulWidget {
  const MyBEtestPage({super.key});

  @override
  State<MyBEtestPage> createState() => _MyBEtestPageState();
}

class _MyBEtestPageState extends State<MyBEtestPage> {

  DatabaseHandler databaseHandler = DatabaseHandler();
  ImageHandler imageHandler = ImageHandler();

  Future<void> getShoppingLists() async {
    List<ShoppingList> shoppingLists = await databaseHandler.getShoppingLists(true);
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
    List<Task> alexTasks = await databaseHandler.getTaskForUser();
    int index = 0;
    for(var task in alexTasks) {
      print("Task $index ----------");
      task.debugPrint();
      index++;
    }
  }

  Future<void> getFavouriteItems() async {
    List<String> items = await databaseHandler.getFavouriteShoppingItems("drogery");
    int index = 0;
    for(var item in items) {
      print("Item $index: $item");
      index++;
    }
  }

  Future<void> getAllRooms() async {
    List<Room> rooms = await databaseHandler.getRooms();

    for(var room in rooms) {
      room.debugPrint();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BE tester"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    child: Text("getTasksForUser(actualUser)"),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: getFavouriteItems,
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("getFavouriteItems(drogery)"),
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
                  MaterialPageRoute(builder: (context) => const MyCreateShoppingListPage()),
                );
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("createShoppingList()"),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            InkWell(
              onTap: getAllRooms,
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("getAllRooms()"),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(),
            ),
            FutureBuilder(
                future: imageHandler.getRoomImage("5"),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Image.memory(snapshot.data!, width: 250, height: 250);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }

}