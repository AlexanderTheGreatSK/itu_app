//Authors: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Database/ImageHandler.dart';
import 'package:itu_app/Pages/LeaderBoardPage.dart';

import '../Database/DataClasses/Reward.dart';

class RewardWidget extends StatefulWidget {
   RewardWidget({super.key, required this.reward, required this.points, required this.update});
  final Reward reward;
  final int points;
  ValueNotifier<bool> update;

  @override
  RewardWidgetState createState() => RewardWidgetState();
}

class RewardWidgetState extends State<RewardWidget> {
  ImageHandler imageHandler = ImageHandler();
  DatabaseHandler databaseHandler = DatabaseHandler();
  bool bought = false;
  int boughtTimes = 0;
  //int points = 0;

  Future<void> buy() async {
    String userId = await databaseHandler.getCurrentUserId();

    await databaseHandler.buyReward(widget.reward);
    await databaseHandler.updateUserPoints(userId, - widget.reward.price);

    setState(() {
      bought = true;
      boughtTimes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.reward.price >= widget.points ? null : () async {
        await buy().then((value) {
          widget.update.value = !widget.update.value;
        });

      },

      child: Container(
        color: bought ? Colors.lightGreen[300] : widget.reward.price <= widget.points ? Colors.deepPurple[200] : Colors.grey[400],
        child: Column(
          children: [
            Image.asset(imageHandler.getLocalRewards(widget.reward.imageId), color: widget.reward.price <= widget.points  ? null : Colors.grey),
            /*FutureBuilder(
                future: imageHandler.getRewardImage(widget.reward.imageId),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Image.memory(snapshot.data!, color: widget.reward.price > widget.points  ? Colors.grey : null,);
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),*/
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "${widget.reward.price} 🏆",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child:bought ?  Text( "$boughtTimes 🛒", style: const TextStyle(fontSize: 20)) : const Text(""),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

}