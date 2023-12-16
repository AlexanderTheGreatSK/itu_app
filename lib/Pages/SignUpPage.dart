import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itu_app/Pages/BEtest.dart';
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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signIn() async {
    UserCredential userCredential = await signInWithGoogle();
    print(userCredential.user?.uid);

    await databaseHandler.safeUserId(userCredential.user!.uid);

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

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBottomNavigationPage()),
    );
  }


  void toTestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBEtestPage()),
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
          (databaseHandler.isMobilePlatform()) ?
          FutureBuilder(
              future: databaseHandler.isUserSaved(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data!) {
                    return nextPageButton();
                  } else {
                    return googleLoginButton();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }) : nextPageButton()
        ],
      ),
    );
  }

  Widget nextPageButton() {
    return Column(
      children: [
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Material(
                elevation: 10.0,
                child: InkWell(
                  onTap: toTestPage,
                  child: Container(
                    height: 150,
                    width: 300,
                    color: Colors.deepPurpleAccent,
                    child: const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          "TEST BE PAGE",
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
    );
  }

  Widget googleLoginButton() {
    return Row(
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
    );
  }
}
