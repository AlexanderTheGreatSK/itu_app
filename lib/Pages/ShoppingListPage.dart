import 'package:flutter/material.dart';

class MyShoppingListPage extends StatefulWidget {
  const MyShoppingListPage({super.key});

  @override
  State<MyShoppingListPage> createState() => _MyShoppingListPageState();
}

class _MyShoppingListPageState extends State<MyShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("SHOPPING LIST"),
      ),
    );
  }
}