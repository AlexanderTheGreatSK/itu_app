import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';

import '../../Database/DatabaseHandler.dart';

class MyCreateShoppingListPage extends StatefulWidget {
  const MyCreateShoppingListPage({super.key});

  @override
  State<MyCreateShoppingListPage> createState() => _MyCreateShoppingListPageState();
}

class _MyCreateShoppingListPageState extends State<MyCreateShoppingListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  String chosenID = "";

  /// PLS do not be lazy as me and use FormTextField -> one controller for group of TextFields :))
  TextEditingController nameController = TextEditingController();
  TextEditingController privateController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController boughtItemsController = TextEditingController();
  TextEditingController itemsController = TextEditingController();

  Future<void> crateNewShoppingList() async {
    bool private = bool.parse(privateController.text);
    List<String> boughtItems = [];
    boughtItems.add(boughtItemsController.text);

    List<String> assignedUsers = [];
    assignedUsers.add(chosenID);

    List<String> items = [];
    items.add(itemsController.text);

    ShoppingList shoppingList = ShoppingList(nameController.text, boughtItems, items, assignedUsers, typeController.text, private);

    databaseHandler.createNewShoppingList(shoppingList);
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
                controller: privateController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Private"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: typeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Type"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: itemsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Items"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: boughtItemsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "BoughtItems"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
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
                onPressed: crateNewShoppingList,
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