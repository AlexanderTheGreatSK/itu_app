import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Database/DataClasses/ShoppingList.dart';
import '../../Database/DatabaseHandler.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({super.key, required this.list, required this.callback});
  final ShoppingList list;
  final VoidCallback callback;

  @override
  State<AddItemWidget> createState() => _AddItemWidget();
}

class _AddItemWidget extends State<AddItemWidget> {
  final TextEditingController _nameController = TextEditingController();
  DatabaseHandler databaseHandler = DatabaseHandler();
  bool isRecent = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {
              print('presse');
            },
            child: TextField(
              controller: _nameController,
              onEditingComplete: () {
                databaseHandler.addItemToShoppingList(
                    widget.list.shoppingListId, _nameController.text);
                widget.callback();
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.add),
                hintText: 'New Item',
              ),
            ),
          ),
        ),

        /// Navigation Recent / Favorites
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isRecent = true;
                  });
                },
                child: Text('RECENT')),
            TextButton(
                onPressed: () {
                  setState(() {
                    isRecent = false;
                  });
                },
                child: Text('FAVOURITES')),
          ],
        ),
        if (isRecent)
          FutureBuilder(
            future:
                databaseHandler.getShoppingListByID(widget.list.shoppingListId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ShoppingList listByID = snapshot.data!;
                return ListView.builder(
                  itemCount: listByID.boughtItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text(listByID.boughtItems[index]);
                  },
                );
              } else {
                return const Center(
                  child:
                      CircularProgressIndicator(color: Colors.deepPurpleAccent),
                );
              }
            },
          ),
        if (!isRecent)
          FutureBuilder(
            future: databaseHandler.getFavouriteShoppingItems(widget.list.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> favList = snapshot.data!;
                return ListView.builder(
                  itemCount: favList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text(favList[index]);
                  },
                );
              } else {
                return const Center(
                  child:
                      CircularProgressIndicator(color: Colors.deepPurpleAccent),
                );
              }
            },
          ),
      ],
    );
  }
}
