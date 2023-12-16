import 'package:flutter/material.dart';
import 'package:itu_app/Pages/ShoppingList/FamilyListPage.dart';
import 'package:itu_app/Pages/ShoppingList/MyListPage.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            leading: Container(),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: "FAMILY LISTS"),
                Tab(text: "MY LISTS"),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: FamilyListPage(),
            ),
            Center(
              child: MyListPage(),
            ),
          ],
        ),
      ),
    );
  }
}
