import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ListOverviewPage.dart';
import 'package:itu_app/Widgets/ListsWidget.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ListsWidgets().menuWidget(),
            FutureBuilder<List<ShoppingList>>(
              future: databaseHandler.getShoppingLists(),
              builder: (BuildContext context, AsyncSnapshot<List<ShoppingList>?> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      String? categoryName = snapshot.data?[index].name;
                      return ListsWidgets().listWidget(categoryName!, "item", context);
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
