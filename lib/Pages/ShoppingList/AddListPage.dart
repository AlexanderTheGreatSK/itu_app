import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import '../../Database/DatabaseHandler.dart';
import '../../Database/DataClasses/ShoppingList.dart';

class AddListPage extends StatefulWidget {
  const AddListPage({super.key, required this.isPrivate});
  final bool isPrivate;

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  ShoppingList newShoppingList = ShoppingList.empty();

  List<String> list = <String>[
    'Grocery',
    'Pet shop',
    'Drugstore',
    'Hobby market',
    'Add my type'
  ];
  String dropdownValue = 'Grocery';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.shopping_cart),
      iconColor: Colors.deepPurple[400],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              newShoppingList.name = value;
            },
            decoration: const InputDecoration(hintText: 'List name'),
          ),
          Row(
            children: [
              const Text('Type: '),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  elevation: 4,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      newShoppingList.type = value!;
                      dropdownValue = value;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  createShoppingList();
                  Navigator.pop(context);
                });
              },
              child: const Text('Create')),
        ),
      ],
    );
  }

  void createShoppingList() async {
    if (widget.isPrivate == true) {
      newShoppingList.assignedUsers.add(await databaseHandler.getCurrentUser());
    } else {
      newShoppingList.assignedUsers = await databaseHandler.getUsers();
    }
    newShoppingList.private = widget.isPrivate;
    databaseHandler.createNewShoppingList(newShoppingList);
  }
}