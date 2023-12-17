import 'package:flutter/material.dart';

import '../../Database/DataClasses/ShoppingList.dart';
import '../../Database/DatabaseHandler.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({super.key, required this.list, required this.item});
  final ShoppingList list;
  final String item;

  @override
  State<ItemWidget> createState() => _ItemWidget();
}

class _ItemWidget extends State<ItemWidget> {
  bool isChecked = false;
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        selectedTileColor: Colors.red, //?
        tileColor: Colors.grey, //?
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        checkboxShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        title: Text(
          widget.item,
          style: const TextStyle(fontSize: 16),
        ));
  }
}
