import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
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
      body: Center(
        child: Column(
          children: [
            FutureBuilder<List<ShoppingList>>(
              future: databaseHandler.getShoppingLists(),
              builder: (BuildContext context, AsyncSnapshot<List<ShoppingList>?> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return const ListOverviewPage();
                    },
                  );
                } else if(snapshot.hasError) {
                  // if error show error.png
                  print("Error");
                  return Container();
                }else {
                  return const CircularProgressIndicator(color: Colors.deepPurpleAccent);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}