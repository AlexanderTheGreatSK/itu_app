///Author: Alena Klimecká - xklime47
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final ValueNotifier<bool> update = ValueNotifier<bool>(false);

  @override

  /// Souhrny pohled na soukrome seznamy
  Widget build(BuildContext context) {
    return Scaffold(

        /// Tlacitko pro pridani noveho seznamu
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 100),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddListPage(isPrivate: true);
                },
              ).then((value) {
                update.value = !update.value;
              });
            },
            backgroundColor: Colors.deepPurple[300],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),

        /// Vypisuje na obrazovku vsechny soukrome seznamy
        body: ValueListenableBuilder<bool>(
          valueListenable: update,
          builder: (context, value, child) {
            return FutureBuilder(
              future: databaseHandler.getShoppingLists(true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ShoppingList> lists = snapshot.data!;
                  return ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      return ListWidget(
                        list: lists[index],
                        callback: () {
                          setState(() {
                            update.value = !update.value;
                          });
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent),
                  );
                }
              },
            );
          },
        ));
  }
}
