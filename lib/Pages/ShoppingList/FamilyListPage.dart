import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/ListOverviewPage.dart';
import 'package:itu_app/Pages/ShoppingList/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class FamilyListPage extends StatefulWidget {
  const FamilyListPage({super.key});

  @override
  State<FamilyListPage> createState() => _FamilyListPageState();
}

class _FamilyListPageState extends State<FamilyListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: databaseHandler.getShoppingLists(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<ShoppingList> lists = snapshot.data!;
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return ListOverviewPage(list: lists[index]);
              },
            );
          } else {
            return const CircularProgressIndicator(
                color: Colors.deepPurpleAccent);
          }
        },
      ),
    );
  }
}
