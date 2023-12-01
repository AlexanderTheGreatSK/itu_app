import 'package:flutter/material.dart';
import 'package:itu_app/Widgets/ListWidget.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OurWidgets().listWidget("Grocery", "item"),
            OurWidgets().listWidget("Household and cleaning", "item"),
            OurWidgets().listWidget("Pet care", "item"),
          ],
        ),
      ),
    );
  }
}