import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class MyBEtestPage extends StatefulWidget {
  const MyBEtestPage({super.key});

  @override
  State<MyBEtestPage> createState() => _MyBEtestPageState();
}

class _MyBEtestPageState extends State<MyBEtestPage> {

  DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> getShoppingLists() async {
    List<ShoppingList> shoppingLists = await databaseHandler.getShoppingLists();
    int index = 0;
    for(ShoppingList shoppingList in shoppingLists) {
      print("ShoppingList $index ----------");
      shoppingList.debugPrint();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BE tester"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: getShoppingLists,
            child: const Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("getShoppingLists()"),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(),
          ),
          /*FutureBuilder(
              future: databaseHandler.getShoppingLists(),
              builder: (BuildContext context, AsyncSnapshot<List<ShoppingList>> snapshot) {
              if(snapshot.hasData) {
                print("HAS DATA");
                print("LEN ${snapshot.data?.length}");
                snapshot.data?[0].debugPrint();
                return Text(snapshot.data!.length.toString());
              } else {
                print("NO DATA YET");
                print("LEN ${snapshot.data?.length}");
                return const CircularProgressIndicator();
              }
          })*/
        ],
      ),
    );
  }

}