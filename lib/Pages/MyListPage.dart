import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ListContent.dart';
import 'package:itu_app/Pages/ListOverviewPage.dart';
import 'package:itu_app/Widgets/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index){
          return const MyListContent();
        },
      )
    );
  }
}
