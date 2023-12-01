import 'package:flutter/material.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 300,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Colors.deepPurple,
          child: const Text(
            "SHOPPING LIST",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),

      ),
    );
  }
}