import 'package:flutter/material.dart';

class MyProblemsPage extends StatefulWidget {
  const MyProblemsPage({super.key});

  @override
  State<MyProblemsPage> createState() => _MyProblemsPageState();
}

class _MyProblemsPageState extends State<MyProblemsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("PROBLEMS"),
      ),
    );
  }
}