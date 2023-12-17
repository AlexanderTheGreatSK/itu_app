import 'package:flutter/material.dart';

import '../../Database/DataClasses/ShoppingList.dart';
import '../../Database/DatabaseHandler.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget(
      {super.key,
      required this.list,
      required this.item,
      required this.bought,
      required this.callback});
  final ShoppingList list;
  final String item;
  final bool bought;
  final VoidCallback callback;

  @override
  State<ItemWidget> createState() => _ItemWidget();
}

class _ItemWidget extends State<ItemWidget> {
  bool isChecked = false;
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    isChecked = widget.bought;
  }

  @override

  /// polozka seznamu
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = true;
                databaseHandler.setItemAsBought(
                    widget.list.shoppingListId, widget.item, true);
                widget.callback();
              });
            },
            title: Text(
              widget.item,
              style: const TextStyle(fontSize: 16),
            )),
        const Divider(
          color: Colors.grey,
          height: 10,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
