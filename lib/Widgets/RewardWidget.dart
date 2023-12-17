import 'package:flutter/material.dart';
import 'package:itu_app/Database/ImageHandler.dart';

import '../Database/DataClasses/Reward.dart';

class RewardWidget extends StatefulWidget {
  const RewardWidget({super.key, required this.reward, required this.points});
  final Reward reward;
  final int points;

  @override
  RewardWidgetState createState() => RewardWidgetState();
}

class RewardWidgetState extends State<RewardWidget> {
  ImageHandler imageHandler = ImageHandler();
  bool bought = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.reward.price > widget.points
          ? null : () {
        setState(() {
          bought = true;
        });
      },

      child: Container(
        color: bought ? Colors.lightGreen[300] : widget.reward.price < widget.points ? Colors.deepPurple[200] : Colors.grey[400],
        child: Column(
          children: [
            Image.asset(imageHandler.getLocalReward(widget.reward.imageId), color: widget.reward.price > widget.points  ? Colors.grey : null,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "${widget.reward.price} 🏆",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

}