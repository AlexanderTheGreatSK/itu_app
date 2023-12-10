import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itu_app/Pages/FridgePage.dart';
import 'package:itu_app/Pages/HomePage.dart';
import 'package:itu_app/Pages/ProblemsPage.dart';
import 'package:itu_app/Pages/ReservationsPage.dart';
import 'package:itu_app/Pages/ShoppingList/ShoppingListPage.dart';
import 'package:itu_app/Widgets/ItemWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Pages/ProfilePage.dart';
import 'Pages/SignUpPage.dart';
import 'Database/firebase_options.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple.shade300,
          // ···
          brightness: Brightness.light,
        ),

        textTheme: GoogleFonts.offsideTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      debugShowCheckedModeBanner: false,
      home: const MyLoginPage(),
    );
  }
}

class MyBottomNavigationPage extends StatefulWidget {
  const MyBottomNavigationPage({super.key});

  @override
  State<MyBottomNavigationPage> createState() => _MyBottomNavigationPageState();
}

class _MyBottomNavigationPageState extends State<MyBottomNavigationPage> {
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
          color: Colors.black
        ),
        title: const Text("Welcome home 👋", style: TextStyle(color: Colors.black)),
        actions: [
          RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfilePage()),
              );
            },
            elevation: 2.0,
            fillColor: const Color(0xFFF5F6F9),
            shape: const CircleBorder(),
            child: const CircleAvatar(
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
        child: const Icon(Icons.add),
      ),*/
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomAppBar(
            elevation: 10.0,
            color: Colors.deepPurple[300],
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