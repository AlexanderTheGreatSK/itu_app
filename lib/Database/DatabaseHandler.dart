import 'dart:io';

import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DatabaseHandler {
  Future<void> addNewRoom(String roomName) async {
    await Hive.box("rooms").add(roomName);
  }

  Future<String> getUsers() async {
    if(isMobilePlatform()) {
      late String ret;
      await FirebaseFirestore.instance.collection("users").limit(10).get().then((snapshot) {
        ret = snapshot.docs.first.data().toString();
      });
      return ret;
    } else {
      Uri uri = Uri.https("firestore.googleapis.com", "v1/projects/nashhouse-6656c/databases/(default)/documents/users");
      var response = await http.get(uri);
      return response.body;
    }
  }

  bool isMobilePlatform() {
    if(Platform.isIOS || Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }
}