import 'package:flutter/material.dart';

import '../../Database/DataClasses/ShoppingList.dart';
import '../../Database/DatabaseHandler.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({super.key, required this.list, required this.callback});
  final ShoppingList list;
  final VoidCallback callback;

  @override
  State<AddItemWidget> createState() => _AddItemWidget();
}

class _AddItemWidget extends State<AddItemWidget> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
