import 'package:flutter/material.dart';
import 'package:itu_app/Database/ImageHandler.dart';

import '../Database/DataClasses/Reward.dart';

class RewardWidget extends StatefulWidget {
  const RewardWidget({super.key, required this.reward});
  final Reward reward;

  @override
  RewardWidgetState createState() => RewardWidgetState();
}

class RewardWidgetState extends State<RewardWidget> {
  ImageHandler imageHandler = ImageHandler();
  bool bought = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          bought = true;
        });
      },
      child: Container(
        color: bought? Colors.lightGreen[300] : Colors.deepPurple[200],
        child: Column(
          children: [
            Image.asset(imageHandler.getLocalReward(widget.reward.imageId)),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text("100 pt", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),

      //Image.asset(imageHandler.getLocalReward(widget.reward.imageId)),
    );
  }

}