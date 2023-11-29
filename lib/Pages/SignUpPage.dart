import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itu_app/Database/DataClasses/User.dart';
import 'package:itu_app/Pages/NewUserPage.dart';
import '../Database/DatabaseHandler.dart';
import '../main.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  /*Future<void> getData() async {
    databaseHandler.getUsers().then((value) {
      print(value);
    });
  }*/

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signIn() async {
    UserCredential userCredential = await signInWithGoogle();
    print(userCredential.user?.uid);

    await databaseHandler.userExists(userCredential.user!.uid).then((exists) {
      print("EXISTS: $exists");
      if(exists) {
        print("user already exists");
        nextPage();
      } else {
        print("Creating new user");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyNewUserPage(userCredential.user!.uid)),
        );

      }
    });
  }


  /*GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );*/

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("NashHouse", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.deepPurpleAccent)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 10.0,
                  child: InkWell(
                    onTap: signIn,
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.deepPurpleAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "SIGN IN WITH GOOGLE",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 10.0,
                  child: InkWell(
                    onTap: nextPage,
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.deepPurpleAccent,
                      child: const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            "NEXT PAGE",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
