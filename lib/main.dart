import 'dart:io';
import 'package:flutter/material.dart';
import 'package:itu_app/Database/DatabaseHandler.dart';
import 'package:itu_app/Database/RoomType.dart';
import 'package:itu_app/Pages/AddNewRoom.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itu_app/Widgets/ItemWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';


Future<void> main() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
  } else {
    await Hive.initFlutter();
  }

  await Hive.openBox('rooms');
  Hive.registerAdapter(RoomClassAdapter());

  print(DefaultFirebaseOptions.currentPlatform);
  if(Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(name: "dev project", options: DefaultFirebaseOptions.currentPlatform);
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My home',
      debugShowCheckedModeBanner: false,
      home: MyLoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OurWidgets ourWidgets = OurWidgets();

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

}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future<void> getData() async {
    databaseHandler.getUsers().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NashHouse"),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: getData,
            child: const Text("Test"),
          )
        ],
      ),
    );
  }
}
