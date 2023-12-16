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
  DatabaseHandler databaseHandler = DatabaseHandler();

  TextEditingController nameController = TextEditingController();
  //TextEditingController progressBarController = TextEditingController();

  void crateNewRoom() {
    Room room = Room(nameController.text, imgIndex.toString(), currentTidinessValue.toInt()*50);

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
            /*Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: progressBarController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "StatusBarNumber"
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            ),*/
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
          onScrolled: _getIndex(),
        ),

        itemCount: imgList.length,
        itemBuilder: (context, index, realIdx) {
          imgIndex = index;
          return Row(
            children: [imgIndex].map((idx) {
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

  _getIndex(){
    setState(() {
      imgIndex++;
    });
  }
}

