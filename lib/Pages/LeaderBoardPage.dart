///Author: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Database/ImageHandler.dart';
import 'package:itu_app/Pages/CreateRewardPage.dart';
import 'package:itu_app/Widgets/RewardWidget.dart';
import '../Database/DataClasses/Reward.dart';


class LeaderBoardPage extends StatefulWidget {
   LeaderBoardPage({super.key, required this.points, required this.userId});
  int points;
  String userId;

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPage();
}

class _LeaderBoardPage extends State<LeaderBoardPage> {
  ///Leaderboard page divided between 3 parts:
    ///First 3 users with most points
    ///Shop with the rewards with custom brick layout
    ///Create new reward ('+')
  DatabaseHandler databaseHandler = DatabaseHandler();
  ImageHandler imageHandler = ImageHandler();
  final ValueNotifier<bool> update = ValueNotifier<bool>(false);

  Future<int> updatePoints() async {
    return (await databaseHandler.getCurrentUser()).points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Leaderboard", style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: (){
            toAddRewardPage();
          },
          backgroundColor: Colors.deepPurple[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))
          ),
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: update,
          builder: (context, value, child) {
            return FutureBuilder(future: updatePoints(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView(
                        children:[
                          leaderBoardWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0, top: 20.0),
                                child: Text("My points: ${snapshot.data!} 🏆", style: const TextStyle(fontSize: 19.0)),
                              ),
                            ],
                          ),
                          _buildMore(snapshot.data!)
                        ]
                    );
                  } else {
                    return Container();
                  }
                });
          })
    );
  }

  ///Reward shop FE handling
  Widget _buildMore(int p) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
      child: FutureBuilder(
          future: databaseHandler.getRewards(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<Reward> rewards = snapshot.data!;

              double width = MediaQuery
                  .of(context)
                  .size
                  .width;

              double midWidth = width / 2;

              List<Widget> stackChildren = [];

              int numberOfRows = (rewards.length / 2).round();

              for (int i = 0; i <= numberOfRows + 1; i += 2) {

                Widget positioned1 = Positioned(
                  width: midWidth - (midWidth / 20),
                  height: 250,
                  top: 130.0 * (i),
                  right: midWidth - (midWidth / 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: RewardWidget(reward: rewards[i], points: p, update: update),
                    ),
                  ),
                );
                stackChildren.add(positioned1);

                if (i + 1 < rewards.length) {
                  Widget positioned2 = Positioned(
                    width: midWidth - (midWidth / 20),
                    height: 250,
                    top: 130.0 * (i) + 25,
                    left: midWidth - (midWidth / 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: RewardWidget(reward: rewards[i+1], points: p, update: update,),
                      ),
                    ),
                  );
                  stackChildren.add(positioned2);
                }
              }

              return SingleChildScrollView(
                child: SizedBox(
                  height: 250.0 * (numberOfRows) + 50,
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

  ///First 3 users with most points
  ///Added custom emojis to the Profile Pictures based on the winning position
  ///Number of points of winning users
  Widget leaderBoardWidget() {
    return FutureBuilder(
      future: databaseHandler.getLeaderBoardUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
          ImageHandler imageHandler = ImageHandler();

          Widget positioned = Container(
            alignment: Alignment.topCenter,
            height: 390.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.deepPurple[200],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)
                )
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage(imageHandler.getLocalUsers(data[0].profilePicture!)),
                            child: const Align(
                              alignment: Alignment.topCenter,
                              child: Text("👑", style: TextStyle(fontSize: 35),),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("${data[0].points}", style: const TextStyle(fontSize: 18,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      spacing: 100,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(imageHandler.getLocalUsers(data[1].profilePicture!)),
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text("🥈", style: TextStyle(fontSize: 35),),
                              ),
                            ),
                            const SizedBox(height: 10), // Adjust the spacing between CircleAvatar and the text
                            Text("${data[1].points}", style: const TextStyle(fontSize: 18),),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(imageHandler.getLocalUsers(data[2].profilePicture!)),
                              child: const Align(
                                alignment: Alignment.topRight,
                                child: Text("🥉", style: TextStyle(fontSize: 35),),
                              ),
                            ),
                            const SizedBox(height: 10), // Adjust the spacing between CircleAvatar and the text
                            Text("${data[2].points}", style: const TextStyle(fontSize: 18),),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          );

          return positioned;

        }else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void toAddRewardPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyCreateRewardPage()),
    ).then((value) {
      update.value = !update.value;
    });
  }
}