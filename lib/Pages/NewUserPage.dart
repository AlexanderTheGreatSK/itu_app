//Authors: Alexander Okrucký (xokruc00)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';

import '../Database/DataClasses/User.dart';
import '../main.dart';

class MyNewUserPage extends StatefulWidget {
  const MyNewUserPage(this.userId, {super.key});

  final String userId;

  @override
  State<MyNewUserPage> createState() => _MyNewUserPageState(userId);
}

class _MyNewUserPageState extends State<MyNewUserPage> {
  final String userId;

  _MyNewUserPageState(this.userId);
  TextEditingController usernameTextField = TextEditingController();
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("New user"),
            backgroundColor: Colors.deepPurpleAccent,
            centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: usernameTextField,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: createUser,
                color: Colors.deepPurpleAccent,
                child: const Text("Create"),
              ),
            )
          ],
        ),
    );
  }

  void createUser() {
    OurUser user = OurUser(usernameTextField.text, userId, "TODO", 0);
    databaseHandler.createNewUser(user);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavigationPage()),
    );
  }

}