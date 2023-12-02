import 'package:flutter/material.dart';
import 'package:itu_app/Widgets/ListsWidget.dart';

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
            ListsWidgets().menuWidget(),
            ListsWidgets().listWidget("Grocery", "item", context),
            ListsWidgets().listWidget("Household and cleaning", "item", context),
            ListsWidgets().listWidget("Pet care", "item", context),
          ],
        ),
      ),
    );
  }
}