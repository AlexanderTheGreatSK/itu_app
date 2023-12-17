import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Database/ImageHandler.dart';
import 'package:itu_app/Pages/CreateRewardPage.dart';
import 'package:itu_app/Widgets/RewardWidget.dart';
import '../Database/DataClasses/Reward.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPage();
}

class _LeaderBoardPage extends State<LeaderBoardPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  ImageHandler imageHandler = ImageHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Leader board", style: TextStyle(color: Colors.black)),
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
      body: ListView(
        children:[
          leaderBoardWidget(),
          _buildMore(MediaQuery.of(context).size)
        ]
      )
    );
  }

  Widget _buildMore(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0, top: 30.0),
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

                print(rewards[i].name);

                Widget positioned1 = Positioned(
                    width: midWidth - (midWidth / 20),
                    height: 250,
                    top: 130.0 * (i),
                    right: midWidth - (midWidth / 20),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: RewardWidget(reward: rewards[i]),
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
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: RewardWidget(reward: rewards[i+1]),
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

  Widget leaderBoardWidget() {
    return Container(
      alignment: Alignment.topCenter,
      height: 350.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.deepPurple[200],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)
          )
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("👑", style: TextStyle(fontSize: 35),),
                  ),
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
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGF2YXRhcnxlbnwwfHwwfHx8MA%3D%3D"),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("🥈", style: TextStyle(fontSize: 35),),
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1450297350677-623de575f31c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text("🥉", style: TextStyle(fontSize: 35),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toAddRewardPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyCreateRewardPage()),
    );
  }
}