import 'package:flutter/material.dart';

import '../Database/DatabaseHandler.dart';
import '../main.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> getData() async {
    databaseHandler.getUsers().then((value) {
      print(value);
    });
  }

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("NashHouse", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.deepPurpleAccent)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 10.0,
                  child: InkWell(
                    onTap: getData,
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.deepPurpleAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "TEST",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 10.0,
                  child: InkWell(
                    onTap: nextPage,
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.deepPurpleAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "NEXT PAGE",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
