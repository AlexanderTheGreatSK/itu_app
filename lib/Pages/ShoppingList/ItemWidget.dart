import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({super.key, required this.item});
  final String item;

  @override
  State<ItemWidget> createState() => _ItemWidget();
}

class _ItemWidget extends State<ItemWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: isChecked,
            activeColor: Colors.grey,
            onChanged: (newBool){
              setState(() {
                isChecked = newBool!;
              });
            }
        ),
        Text(widget.item),
      ],
    );
  }

}