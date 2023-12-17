///Author: Jana Kováčiková (xkovac59)

import 'package:flutter/material.dart';
import 'package:itu_app/Pages/Rooms/RoomsPage.dart';
import 'package:itu_app/Pages/Tasks/TasksPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabBarHomePage()
    );
  }
}

class TabBarHomePage extends StatefulWidget {
  const TabBarHomePage({super.key});

  @override
  State<TabBarHomePage> createState() => _TabBarState();
}

class _TabBarState extends State<TabBarHomePage> with TickerProviderStateMixin {
  ///TabBar for page swap between MyTasksPage and MyRoomsPage
  ///default option is the Tasks page

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                text: "Tasks",
              ),
              Tab(
                text: "Rooms",
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: MyTasksPage(),
          ),
          Center(
            child: MyRoomsPage(),
          ),
        ],
      ),
    );
  }
}