import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/ListContent.dart';
import 'package:itu_app/Pages/ShoppingList/ListOverviewPage.dart';
import 'package:itu_app/Pages/ShoppingList/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: databaseHandler.getShoppingLists(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<ShoppingList> lists = snapshot.data!;
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return listWidget(lists[index]);
              },
            );
          } else {
            return const CircularProgressIndicator(
                color: Colors.deepPurpleAccent);
          }
        },
      ),
    );
  }

  Widget listWidget(ShoppingList list) {
    bool isActive = false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InkWell(
            onTap: () {
              setState(() {
                isActive = !isActive;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: isActive
                    ? const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))
                    : BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          elevation: 10,
                          showDragHandle: true,
                          backgroundColor: Colors.grey,
                          builder: (BuildContext context) {
                            return bottomBarWidget(context);
                          });
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isActive)
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  // tady budou jednotlive itemy a checboxy, musim to dat mimo po jednom
                  child: const Row(
                    children: [
                      Text(
                        "Banana",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ))),
      ],
    );
  }

  // vyskakovaci obrazovka spodku
  @override
  Widget bottomBarWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Rename",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.change_circle,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Change category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Delete List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ]),
    );
  }

}
