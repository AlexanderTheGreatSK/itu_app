///Author: Alena Klimecká - xklime47
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

  /// pridani nove polozky
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// pridani pomoci vepsani
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {
              print('pressed');
            },
            child: TextField(
              controller: _nameController,
              onEditingComplete: () {
                databaseHandler.addItemToShoppingList(
                    widget.list.shoppingListId, _nameController.text);
                _nameController.clear();
                widget.callback();
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.add),
                hintText: 'New Item',
              ),
            ),
          ),
        ),

        /// Navigace recent / suggested
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isRecent = true;
                  });
                },
                child: const Text('RECENT')),
            TextButton(
                onPressed: () {
                  setState(() {
                    isRecent = false;
                  });
                },
                child: const Text('SUGGESTED')),
          ],
        ),

        /// pridani z recent
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itemOffer(context, listByID.boughtItems[index]);
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

        /// pridani z suggested
        if (!isRecent)
          FutureBuilder(
            future: databaseHandler.getFavouriteShoppingItems(widget.list.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> favList = snapshot.data!;
                return ListView.builder(
                  itemCount: favList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itemOffer(context, favList[index]);
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

  /// nabizena polozka
  Widget itemOffer(BuildContext context, String offer) {
    return TextButton(
      onPressed: () {
        databaseHandler.addItemToShoppingList(
            widget.list.shoppingListId, offer);
        databaseHandler.setItemAsBought(
            widget.list.shoppingListId, offer, false);
        widget.callback();
      },
      child: Row(
        children: [
          Icon(Icons.add),
          Text(
            offer,
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
