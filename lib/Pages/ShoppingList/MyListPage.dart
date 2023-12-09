import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/ListContent.dart';
import 'package:itu_app/Pages/ShoppingList/ListOverviewPage.dart';
import 'package:itu_app/Pages/ShoppingList/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  List<bool> isActive = [];

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
