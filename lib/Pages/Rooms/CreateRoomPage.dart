///Author: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DataClasses/Room.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:carousel_slider/carousel_slider.dart';


final List<String> imgList = [
  "res/images/1.png",
  "res/images/2.png",
  "res/images/3.png",
  "res/images/4.png",
  "res/images/5.png",
  "res/images/6.png",
  "res/images/7.png",
  "res/images/8.png",
  "res/images/9.png",
  "res/images/10.png",
  "res/images/11.png",
  "res/images/12.png",
  "res/images/13.png",
  "res/images/14.png",
  "res/images/15.png",
];


class MyCreateRoomPage extends StatefulWidget {
  const MyCreateRoomPage({super.key});

  @override
  State<MyCreateRoomPage> createState() => _MyCreateRoomPageState();
}

class _MyCreateRoomPageState extends State<MyCreateRoomPage> {
  ///Creating a new room with error handling
  DatabaseHandler databaseHandler = DatabaseHandler();

  TextEditingController nameController = TextEditingController();

  void crateNewRoom() {
    Room room = Room(nameController.text, imgIndex.toString(), currentTidinessValue.toInt()*50);
    print("ROOOM IMG : ${room.imageId}");
    databaseHandler.createRoom(room).onError((error, stackTrace) {
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

  ///Widget with text field for the name of a room
  ///CarouselSlider for choosing the room image
  ///Current tidiness of the room slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new room"),
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
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Current tidiness:", style: TextStyle(fontSize: 20.0))
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
              child: Slider(
                value: currentTidinessValue,
                min: 0,
                max: 2,
                divisions: 2,
                label: ["Low", "Medium", "High"][currentTidinessValue.round()],
                onChanged: (double value) {
                  setState(() {
                    currentTidinessValue = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: crateNewRoom,
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
}

