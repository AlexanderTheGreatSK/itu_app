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
            onPressed: (){
              createShoppingList();
              Navigator.of(context).pop();
            },
              child: const Text('Create')
          ),
        ),
      ],
    );
  }

  void createShoppingList() async {
    if(widget.isPrivate == true){
      newShoppingList.assignedUsers.add(await databaseHandler.getCurrentUser());
    } else {
      newShoppingList.assignedUsers = await databaseHandler.getUsers();
    }
    newShoppingList.private = widget.isPrivate;
    databaseHandler.createNewShoppingList(newShoppingList);
  }


}