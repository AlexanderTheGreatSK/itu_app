import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/AddListPage.dart';
import 'package:itu_app/Pages/ShoppingList/ListWidget.dart';
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
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddListPage(isPrivate: true);
              },
            );
          },
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
      body: FutureBuilder(
        future: databaseHandler.getShoppingLists(true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ShoppingList> lists = snapshot.data!;
            return ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                if(lists[index].private == true){
                  return ListWidget(list: lists[index]);
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
