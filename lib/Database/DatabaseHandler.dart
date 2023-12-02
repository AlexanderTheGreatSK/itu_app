import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'DataClasses/ShoppingList.dart';
import 'DataClasses/ShoppingListItem.dart';
import 'DataClasses/User.dart';

class DatabaseHandler {

  Future<void> addNewRoom(String roomName) async {
    await Hive.box("rooms").add(roomName);
  }

  Future<void> createNewUser(OurUser user) async {
    final userMap = <String, dynamic> {
      "username" : user.username,
      "profilePicture" : user.profilePicture,
      "points" : user.points,
      "userId" : user.userId,
    };

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("users").doc(user.userId).set(userMap).onError((error, stackTrace) => print("Error: $error, $stackTrace"));
    }
  }

  Future<bool> userExists(String userId) async {
    bool exists = false;

    await FirebaseFirestore.instance.collection("users").doc(userId).get().then((snapshot) {
      exists = snapshot.exists;
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
    return exists;
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

  Future<OurUser?> getUserById(String userId) async {
    OurUser user;

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("users").doc(userId).get().then((snapshot) {
        if(snapshot.exists) {
          var userMap = snapshot.data(),
          user = OurUser(userMap?["username"], userMap?["userId"], userMap?["profilePicture"], userMap?["points"]);
          return user;
        }
      });
    } else {
      Uri uri = Uri.https("firestore.googleapis.com", "v1/projects/nashhouse-6656c/databases/(default)/documents/users/$userId");
      var response = await http.get(uri);
      Map body = jsonDecode(response.body);
      user = OurUser(body["username"], body["userId"], body["profilePicture"], body["points"]);
      return user;
    }
    return null;
  }

  bool isMobilePlatform() {
    if(Platform.isIOS || Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ShoppingList>> getShoppingLists() async {
    List<ShoppingList> shoppingLists = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("shoppingLists").get().then((snapshot) async {
        var docsMap = snapshot.docs;
        for(var item in docsMap) {
          List<String> boughtItems = [];
          List<String> items = [];
          List<OurUser> assignedUsers = [];

          for(var bItem in item.data()["boughtItems"]) {
            boughtItems.add(bItem);
          }
          for(var nItem in item.data()["items"]) {
            items.add(nItem);
          }

          for(var user in item.data()["assignedUsers"]) {
            OurUser? ourUser = await getUserById(user);
            if(ourUser != null) {
              assignedUsers.add(ourUser);
            }
          }
          String name = item.data()["name"];
          String type = item.data()["type"];

          shoppingLists.add(ShoppingList(name, boughtItems, items, assignedUsers, type));
        }
      });
    }

    return shoppingLists;
  }
}