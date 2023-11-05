import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itu_app/Class/RoomType.dart';
import 'package:itu_app/Pages/AddNewRoom.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  await Hive.openBox('rooms');
  Hive.registerAdapter(RoomClassAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("My home"),
      ),
      body: FutureBuilder<Box> (
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
                      return getRoomWidget(snapshot.data!.getAt(index));
                    },
                  );
                }
              },
            );
          } else {
            return const CircularProgressIndicator(color: Colors.purpleAccent,);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewRoom()),
          );
        },
        tooltip: 'Create new room',
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getRoomWidget(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 10, right: 100, bottom: 10.0),
      child: Material(
        elevation: 20,
        child: Container(
          height: 100,
          child: Center(
            child: Text(name, style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }

}
