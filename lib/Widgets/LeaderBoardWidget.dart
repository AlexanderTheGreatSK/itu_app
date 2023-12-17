//Authors: Jana Kováčiková (xkovac59)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itu_app/Database/ImageHandler.dart';
import '../Database/DataClasses/User.dart';

class LeaderBoardWidget extends StatefulWidget {
  const LeaderBoardWidget({super.key, required this.user});
  final OurUser user;

  @override
  LeaderBoardWidgetState createState() => LeaderBoardWidgetState();
}

class LeaderBoardWidgetState extends State<LeaderBoardWidget> {

  ImageHandler imageHandler = ImageHandler();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          FutureBuilder(
              future: imageHandler.getUserImage(widget.user.profilePicture),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Image.memory(snapshot.data!);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("${widget.user.points} 🏆", style: const TextStyle(fontSize: 20)),
              ),
            ],
          )
        ],
      )
      //Image.asset(imageHandler.getLocalReward(widget.reward.imageId)),
    );
  }

}