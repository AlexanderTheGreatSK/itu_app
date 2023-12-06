import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/FamilyListPage.dart';
import 'package:itu_app/Pages/ListOverviewPage.dart';
import 'package:itu_app/Widgets/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          bottom: const TabBar(
            labelColor: Colors.purple,
            tabs: <Widget>[
              Tab(text: "FAMILY LISTS"),
              Tab(text: "MY LISTS"),
            ],
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

class MyListPage extends StatelessWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("My List Page");
  }
}
