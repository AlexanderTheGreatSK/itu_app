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
    );
  }
}