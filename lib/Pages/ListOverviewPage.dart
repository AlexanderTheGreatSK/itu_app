import 'package:flutter/material.dart';

class ListOverviewPage extends StatefulWidget {
  const ListOverviewPage({super.key});

  @override
  State<ListOverviewPage> createState() => _ListOverviewPage();
}

class _ListOverviewPage extends State<ListOverviewPage> {
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
             setState(() {isActive = !isActive;});},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text(
                    "something",
                    style:  TextStyle(
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
                          backgroundColor: Colors.deepPurple[300],
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
        if(isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Text(
                        "something",
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                       Text(
                        "something something",
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
          )
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
