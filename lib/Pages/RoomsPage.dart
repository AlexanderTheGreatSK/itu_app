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


              return ListView.builder(
                  itemCount: ((room.length / 3) * 2).round(),
                  itemBuilder: (context, index) {

                  if(index.isEven){
                    evenRow++;
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                                  future: imageHandler.getRoomImage(room[index+oddRow].imageId),
                                  builder: (context, snapshotImage) {
                                    if (snapshotImage.hasData) {
                                       return Image.memory(snapshotImage.data!, width: 180, height: 180);
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                          ),
                          FutureBuilder(
                            future: imageHandler.getRoomImage(room[index+oddRow+1].imageId),
                            builder: (context, snapshotImage) {
                              if (snapshotImage.hasData) {
                                return Image.memory(snapshotImage.data!, width: 180, height: 180);
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    oddRow++;
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: imageHandler.getRoomImage(room[index+evenRow].imageId),
                            builder: (context, snapshotImage) {
                              if (snapshotImage.hasData) {
                                return Image.memory(snapshotImage.data!, width: 180, height: 180);
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }
              }
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
    /*var h = 220.0;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {
                      const snackBar = SnackBar(content: Text('Living room'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: FutureBuilder<Uint8List?>(
                      future: imageHandler.getRoomImage("1"),
                      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                        if(snapshot.hasData) {
                          return Image.memory(snapshot.data!);
                        } else if(snapshot.hasError) {
                          // if error show error.png
                          print("Error");
                          return Container();
                        } else {
                          return const CircularProgressIndicator(color: Colors.deepPurpleAccent);
                        }
                      }
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F2.png?alt=media&token=a7f4626e-2b9d-40f4-acd9-c95c42452121", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F3.png?alt=media&token=888fdd79-9da8-4aaa-a304-a2b608e7577e", fit: BoxFit.fitHeight),
                ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F4.png?alt=media&token=cac0881e-7534-4a8f-b08f-1e8e2568ba0e", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: HexagonWidget.pointy(
                  height: h,
                  child: InkWell(
                    onTap: () {},
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/nashhouse-6656c.appspot.com/o/rooms%2F5.png?alt=media&token=ffd74039-2499-4854-8f33-1f6e9791e376", fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );*/
  }

  void toAddNewRoomPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewRoom()),
    );
  }
}