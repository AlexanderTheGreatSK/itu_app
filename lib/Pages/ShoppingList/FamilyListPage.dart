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
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<List<ShoppingList>>(
                  future: databaseHandler.getShoppingLists(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ShoppingList>?> snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return const ListOverviewPage();
                          },
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator(
                          color: Colors.deepPurpleAccent);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
