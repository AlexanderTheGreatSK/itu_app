import 'package:flutter/material.dart';
import 'package:itu_app/Pages/Tasks/CreateTaskPage.dart';
import 'package:itu_app/Pages/Tasks/TodayTasksPage.dart';
import 'package:itu_app/Pages/Tasks/WeekTasksPage.dart';

import 'CalendarTasksPage.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key});

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabBarTasksPage(),
    );
  }
}

class TabBarTasksPage extends StatefulWidget {
  const TabBarTasksPage({super.key});

  @override
  State<TabBarTasksPage> createState() => _TabBarState();
}

class _TabBarState extends State<TabBarTasksPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void handleTabIndex() {
    print(_tabController.index);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          leading: Container(),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: "Today",
              ),
              Tab(
                text: "Week",
              ),
              Tab(
                text: "Calendar",
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: TodayTasksPage(),
          ),
          Center(
            child: WeekTasksPage(),
          ),
          Center(
            child: CalendarTasksPage(),
          ),
        ],
      ),
      floatingActionButton: (_tabController.index != 2) ? Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          tooltip: "Create new task",
          enableFeedback: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCreateTaskPage()),
            );
          },
          child: const Icon(Icons.add_task),
        ),
      ) : Container(),
    );
  }
}

/*FutureBuilder<Box> (
        future: Hive.openBox('rooms'),
        builder: (context, AsyncSnapshot<Box> snapshot) {
          if(snapshot.hasData) {
            return ValueListenableBuilder<Box>(
              valueListenable: Hive.box("rooms").listenable(),
              builder: (context, Box<dynamic> box, widget) {
                if(box.isEmpty) {
                  return const Center(
                    child: Text("No room created."),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ourWidgets.roomWidget(snapshot.data!.getAt(index));
                    },
                  );
                }
              },
            );
          } else {
            return const CircularProgressIndicator(color: Colors.purpleAccent,);
          }
        },
      ),*/