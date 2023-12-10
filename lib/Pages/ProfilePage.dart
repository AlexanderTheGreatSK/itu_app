import 'package:flutter/material.dart';
import 'package:itu_app/Pages/LeaderBoardPage.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePage();
}

class _MyProfilePage extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        title: const Text("My profile", style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          coverImage(),
          profileContent(),
        ],
      )
    );
  }

  Widget coverImage() => const CircleAvatar(
        radius: 110,
        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
  );

  Widget profileContent() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
            onPressed: toLeaderBoardPage,
            child: const Text("🏆 100 pt", style: TextStyle(fontSize: 30),),
        //child: Text("🏆 100 pt", style: TextStyle(fontSize: 30)),
        ),
      ),
    ],
  );

  void toLeaderBoardPage() {
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LeaderBoardPage()),
  );
  }
}