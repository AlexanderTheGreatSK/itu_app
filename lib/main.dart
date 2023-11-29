import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itu_app/Pages/FridgePage.dart';
import 'package:itu_app/Pages/HomePage.dart';
import 'package:itu_app/Pages/ProblemsPage.dart';
import 'package:itu_app/Pages/ReservationsPage.dart';
import 'package:itu_app/Pages/ShoppingListPage.dart';
import 'package:itu_app/Widgets/ItemWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Pages/SignUpPage.dart';
import 'Database/firebase_options.dart';


Future<void> main() async {

  /// Hive local database initialization is not needed at the moment
  /// maybe we will need it later for some setting or themes, idk
  /// so we can delete it later :D
  /*if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    final document = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(document.path);
  } else {
    await Hive.initFlutter();
  }*/

  if(Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(name: "dev project", options: DefaultFirebaseOptions.currentPlatform);
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static MaterialColor deepPurple = const MaterialColor(
    0xFF9575CD,
    <int, Color>{
      50: Color(0xFFEDE7F6),
      100: Color(0xFFD1C4E9),
      200: Color(0xFFB39DDB),
      300: Color(0xFF9575CD),
      400: Color(0xFF7E57C2),
      500: Color(0xFF673AB7),
      600: Color(0xFF5E35B1),
      700: Color(0xFF512DA8),
      800: Color(0xFF4527A0),
      900: Color(0xFF311B92),
    },
  );

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My home',
      debugShowCheckedModeBanner: false,
      home: MyLoginPage(),
    );
  }
}

class MyBottomNavigationPage extends StatefulWidget {
  const MyBottomNavigationPage({super.key});

  @override
  State<MyBottomNavigationPage> createState() => _MyBottomNavigationPageState();
}

class _MyBottomNavigationPageState extends State<MyBottomNavigationPage> {
  OurWidgets ourWidgets = OurWidgets();
  List<Widget> pages = [const MyHomePage(), const MyShoppingListPage(), const MyReservationsPage(), const MyFridgePage(), const MyProblemsPage()];
  List<bool> selectedPage = [true, false, false, false, false];
  int index = 0;

  void selectNewIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("My home", style: TextStyle(color: Colors.white)),
      ),
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomAppBar(
            elevation: 10.0,
            color: Colors.deepPurpleAccent,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Spacer(),
                  customBottomNavBarItem(const Icon(Icons.home, color: Colors.white), "Home", 0),
                  const Spacer(),
                  customBottomNavBarItem(const Icon(Icons.list, color: Colors.white), "Shopping lists", 1),
                  const Spacer(),
                  customBottomNavBarItem(const Icon(Icons.access_time, color: Colors.white), "Reservations", 2),
                  const Spacer(),
                  customBottomNavBarItem(const Icon(Icons.kitchen_rounded, color: Colors.white), "Fridge", 3),
                  const Spacer(),
                  customBottomNavBarItem(const Icon(Icons.report, color: Colors.white), "Problems", 4),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget customBottomNavBarItem(Icon icon, String text, int newIndex) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPage[index] = false;
            selectedPage[newIndex] = true;
            index = newIndex;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (selectedPage[newIndex]) ? icon : SizedBox(width: 50, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon])),
            (selectedPage[newIndex]) ? Text(text, style: const TextStyle(color: Colors.white)) : Container(),
          ],
        ),
      ),
    );
  }

}