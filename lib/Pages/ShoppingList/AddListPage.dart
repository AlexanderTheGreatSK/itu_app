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
  ShoppingList newShoppingList =  ShoppingList.empty();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.shopping_cart),
      iconColor: Colors.deepPurple[400],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: TextField(
        onChanged: (value) {
          newShoppingList.name = value;
        },
        decoration: const InputDecoration(hintText: 'List name'),
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () {
              if(widget.isPrivate == true){
                FutureBuilder(
                    future: databaseHandler.getCurrentUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      newShoppingList.assignedUsers.add(snapshot.data);
                      return Container();
                    }
                );
              } else {
                FutureBuilder(
                    future: databaseHandler.getUsers(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      newShoppingList.assignedUsers = snapshot.data;
                      return Container();
                    }
                );
              }
              newShoppingList.private = widget.isPrivate;
              databaseHandler.createNewShoppingList(newShoppingList);
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ),
      ],
    );
  }


}