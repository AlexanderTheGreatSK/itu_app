///Author: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/Reward.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  "res/rewards/1.png",
  "res/rewards/2.png",
  "res/rewards/3.png",
  "res/rewards/4.png",
  "res/rewards/5.png",
  "res/rewards/6.png",
  "res/rewards/7.png",
  "res/rewards/8.png",
  "res/rewards/9.png",
  "res/rewards/10.png",
  "res/rewards/11.png",
  "res/rewards/12.png",
];

class MyCreateRewardPage extends StatefulWidget {
  const MyCreateRewardPage({super.key});

  @override
  State<MyCreateRewardPage> createState() => _MyCreateRewardPageState();
}

class _MyCreateRewardPageState extends State<MyCreateRewardPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  TextEditingController nameController = TextEditingController();
  TextEditingController rewardController = TextEditingController();

  void crateNewReward() {
    ///Creating a new reward with error handling
    Reward reward = Reward(nameController.text, int.parse(rewardController.text), imgIndex.toString(), true, "");

    print(nameController.text);
    print(rewardController.text);
    print(imgIndex);

    databaseHandler.createReward(reward).onError((error, stackTrace) {
      print("ERROR OCCURED");
      print(error);
      print(stackTrace);
    });

    Navigator.pop(context);

  }

  final FixedExtentScrollController controller = FixedExtentScrollController();
  CarouselController buttonCarouselController = CarouselController();
  int imgIndex = 0;
  double currentTidinessValue = 1;

  ///Widget with text field for the name of a reward
  ///CarouselSlider for choosing the reward image
  ///Text field for the reward price

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new reward"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name"
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: myF(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: rewardController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Reward price 🏆"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: crateNewReward,
                color: Colors.deepPurple[300],
                textColor: Colors.white,
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget myF() {
    return Container(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          scrollDirection: Axis.horizontal,
          viewportFraction: 0.45,
          scrollPhysics: const BouncingScrollPhysics(),
          onPageChanged: yay
        ),

        itemCount: imgList.length,
        itemBuilder: (context, index, realIdx) {
          return Row(
            children: [index].map((idx) {
              return Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(imgList[idx], fit: BoxFit.cover),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  yay(int i, CarouselPageChangedReason reason){
    setState(() {
      imgIndex = i+1;
    });
    print(imgIndex);
  }

  _getIndex(){
    print("Scrolled");
    print(imgIndex);
    //setState(() {
      imgIndex++;
    //});
  }
}

