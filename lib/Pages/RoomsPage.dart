import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Pages/AddNewRoom.dart';
import 'package:itu_app/Pages/BEtestPages/CreateRoomPage.dart';
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
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
      body: _buildMore(MediaQuery.of(context).size),
    );
  }

  Widget _buildMore(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: databaseHandler.getRooms(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<Room> rooms = snapshot.data!;

              double width = MediaQuery.of(context).size.width;

              double midWidth = width / 2;

              List<Widget> stackChildren = [];
              int numberOfRows = ((rooms.length / 3) * 2).round();
              int evenRow = 0;
              int oddRow = 0;


              for(int i = 0; i < numberOfRows; i++) {
                if(i.isEven) {
                  evenRow++;

                  Widget positioned1 = Positioned(
                    child: roomWidget(rooms[i+oddRow].imageId),
                    width: midWidth - (midWidth/20),
                    top: (midWidth - (midWidth/20)*5) * (i),
                    right: midWidth - (midWidth/20),
                  );
                  stackChildren.add(positioned1);

                  if(i+oddRow+1 < rooms.length) {
                    Widget positioned2 = Positioned(
                      child: roomWidget(rooms[i+oddRow+1].imageId),
                      width: midWidth - (midWidth/20),
                      top: (midWidth - (midWidth/20)*5) * (i),
                      left: midWidth - (midWidth/20),
                    );

                    stackChildren.add(positioned2);
                  }
                } else {
                  oddRow++;
                  Widget positioned = Positioned(
                    child: roomWidget(rooms[i+evenRow].imageId),
                    width: midWidth - (midWidth/20),
                    top:(midWidth - (midWidth/20)*5) * (i),
                  );
                  stackChildren.add(positioned);
                }
              }

              return SingleChildScrollView(
                child: SizedBox(
                  height: (midWidth - (midWidth/20)*5) * (numberOfRows + 1),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.center,
                    children: stackChildren,
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
      MaterialPageRoute(builder: (context) => const MyCreateRoomPage()),
    );
  }
}