import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/AddNewRoom.dart';
import '../Database/DataClasses/Room.dart';
import '../Database/ImageHandler.dart';

class MyRoomsPage extends StatefulWidget {
  const MyRoomsPage({super.key});

  @override
  State<MyRoomsPage> createState() => _MyRoomsPageState();
}

class _MyRoomsPageState extends State<MyRoomsPage> {
  ImageHandler imageHandler = ImageHandler();
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: (){
            toAddNewRoomPage();
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: _buildMore(MediaQuery.of(context).size),
    );
  }

  Widget _buildMore(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder(
          future: databaseHandler.getRooms(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<Room> room = snapshot.data!;
              int oddRow = 0;
              int evenRow = 0;
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              double midWidth = width / 2;

              print("Height: $height");
              print("Width: $width");
              print("Width: $midWidth");
              print(room[0].imageId);

              return SingleChildScrollView(
                child: SizedBox(
                  height: 5000,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                        child: roomWidget(room[0].imageId),
                        width: midWidth - (midWidth/20),
                        top: 10,
                        right: midWidth - (midWidth/20),
                      ),
                      Positioned(
                        child: roomWidget(room[1].imageId),
                        width: midWidth - (midWidth/20),
                        top: 10,
                        left: midWidth - (midWidth/20),
                      ),
                      Positioned(
                        child: roomWidget(room[2].imageId),
                        width : midWidth - (midWidth/20),
                        top: (height/(5.5)),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }

  Widget roomWidget(String imageId) {
    return Image.asset(imageHandler.getLocalImage(imageId));
    /*return FutureBuilder(
      future: imageHandler.getRoomImage(imageId),
      builder: (context, snapshotImage) {
        if (snapshotImage.hasData) {
          return InkWell(onTap: () {}, child: Image.memory(snapshotImage.data!));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );*/
  }

  void toAddNewRoomPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewRoom()),
    );
  }
}