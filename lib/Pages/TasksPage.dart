import 'package:flutter/material.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key});

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("TASKS"),
      ),
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