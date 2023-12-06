import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/FamilyListPage.dart';
import 'package:itu_app/Pages/MyListPage.dart';
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
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: "FAMILY LISTS",
            ),
            Tab(
              text: "MY LISTS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: FamilyListPage(),
          ),
          Center(
            child: MyListPage(),
          ),
        ],
      ),
    );
  }
}