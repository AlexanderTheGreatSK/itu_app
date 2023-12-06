import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

class ListOverviewPage extends StatefulWidget {
  const ListOverviewPage({super.key});

  @override
  State<ListOverviewPage> createState() => _ListOverviewPage();
}

class _ListOverviewPage extends State<ListOverviewPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return listOverview(context);
  }

  Widget listOverview(BuildContext context) {
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
                  FutureBuilder(
                      future: databaseHandler.getShoppingLists(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData) {
                          return Text(
                            snapshot.data[0].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  // tady budou jednotlive itemy a checboxy, musim to dat mimo po jednom
                  child: const Row(
                    children: [
                      Text(
                        "Banana",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ))),
      ],
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
