import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/ListWidget.dart';
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
        future: databaseHandler.getShoppingLists(false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ShoppingList> lists = snapshot.data!;
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                if(lists[index].private == false){
                  return ListOverviewPage(list: lists[index]);
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent),
            );
          }
        },
      ),
    );
  }
}
