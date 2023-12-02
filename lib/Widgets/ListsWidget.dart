import 'package:flutter/material.dart';

class ListsWidgets {
  // widget pro menu
  Widget menuWidget() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Family lists",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              "My lists",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget pro jednotlive seznamy, zatim jen jmeno a ikona
  Widget listWidget(String name, String item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
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
