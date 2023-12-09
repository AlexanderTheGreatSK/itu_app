import 'package:flutter/material.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPage();
}

class _LeaderBoardPage extends State<LeaderBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leader board", style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children:[ Container(
          alignment: Alignment.topCenter,
          height: 350.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.deepPurple[300],
              borderRadius: const BorderRadius.all(Radius.circular(24))
          ),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage("https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text("👑", style: TextStyle(fontSize: 35),),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 100,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGF2YXRhcnxlbnwwfHwwfHx8MA%3D%3D"),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("🥈", style: TextStyle(fontSize: 35),),
                        ),
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage("https://images.unsplash.com/photo-1450297350677-623de575f31c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text("🥉", style: TextStyle(fontSize: 35),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),]
      )
    );
  }
}