import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/ShoppingList.dart';
import 'package:itu_app/Pages/ShoppingList/ItemWidget.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key, required this.list});
  final ShoppingList list;

  @override
  State<ListWidget> createState() => _ListWidget();
}

class _ListWidget extends State<ListWidget> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InkWell(
            onTap: () {
              setState(() {
                isActive = !isActive;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: isActive
                    ? const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))
                    : BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.list.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          elevation: 10,
                          showDragHandle: true,
                          backgroundColor: Colors.grey,
                          builder: (BuildContext context) {
                            return bottomBarWidget(context);
                          });
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    spreadRadius: 1
                )],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: widget.list.items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemWidget(item: widget.list.items[index]);
                    },
                  ),
                  addNewItemBar(context),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget addNewItemBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
        return SearchBar(
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 10.0)),
            shape: const MaterialStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            backgroundColor: const MaterialStatePropertyAll<Color>( Colors.white70),
            hintText: "Add new item",
        );
      }, suggestionsBuilder:
              (BuildContext context, SearchController controller) {
        const Text("data");
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      }),
    );
  }

  // vyskakovaci obrazovka spodku
  Widget bottomBarWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Rename",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.change_circle,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Change category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Text(
                  "Delete List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
