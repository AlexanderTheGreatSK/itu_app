import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'DataClasses/ShoppingList.dart';
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

  Future<List<OurUser>> getUsers() async {
    List<OurUser> users = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("users").get().then((snapshot) {
        var docsMap = snapshot.docs;
        for(var item in docsMap) {
          print(item.data());
          var data = item.data();
          users.add(OurUser(data["username"], data["userId"], data["profilePicture"], data["points"]));
        }
      });
      return users;
    } else {
      Uri uri = Uri.https("firestore.googleapis.com", "v1/projects/nashhouse-6656c/databases/(default)/documents/users");
      var response = await http.get(uri);
      Map data = json.decode(response.body);
      for(var item in data["documents"]) {
        var fields = item["fields"];
        String username = fields["username"]["stringValue"];
        String profilePicture = fields["profilePicture"]["stringValue"];
        int points = int.parse(fields["points"]["integerValue"]);
        String userId = fields["userId"]["stringValue"];

        users.add(OurUser(username, userId, profilePicture, points));
      }
      return users;
    }
  }

  Future<OurUser> getUserById(String userId) async {
    OurUser user;

    if(isMobilePlatform()) {
      var snapshot = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      print(snapshot.data());
      return OurUser(snapshot.data()?["username"], snapshot.data()?["userId"], snapshot.data()?["profilePicture"], snapshot.data()?["points"]);
    } else {
      Uri uri = Uri.https("firestore.googleapis.com", "v1/projects/nashhouse-6656c/databases/(default)/documents/users/$userId");
      var response = await http.get(uri);
      Map body = jsonDecode(response.body);
      body = body["fields"];
      user = OurUser(body["username"]["stringValue"], body["userId"]["stringValue"], body["profilePicture"]["stringValue"], int.parse(body["points"]["integerValue"]));
      return user;
    }
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
          bool private = item.data()["private"];
          shoppingLists.add(ShoppingList(name, boughtItems, items, assignedUsers, type, private));
        }
      });
    } else {
      Uri uri = Uri.https("firestore.googleapis.com", "v1/projects/nashhouse-6656c/databases/(default)/documents/shoppingLists");
      var response = await http.get(uri);
      Map data = json.decode(response.body);
      for(var item in data["documents"]) {
        var fields = item["fields"];
        String name = fields["name"]["stringValue"];
        String type = fields["type"]["stringValue"];
        bool private = fields["private"]["booleanValue"];
        List<String> items = [];
        List<String> boughtItems = [];
        List<OurUser> assignedUsers = [];

        var rawItems = fields["items"]["arrayValue"]["values"];
        for(var item in rawItems) {
          items.add(item["stringValue"]);
        }
        var rawBoughtItems = fields["boughtItems"]["arrayValue"];
        if(rawBoughtItems.isNotEmpty) {
          rawBoughtItems = rawBoughtItems["values"];
          for(var item in rawBoughtItems) {
            boughtItems.add(item["stringValue"]);
          }
        }

        var rawUsers = fields["assignedUsers"]["arrayValue"];
        if(rawUsers.isNotEmpty) {
          rawUsers = rawUsers["values"];
          for(var item in rawUsers) {
            assignedUsers.add(await getUserById(item["stringValue"]));
          }
        }

        shoppingLists.add(ShoppingList(name, boughtItems, items, assignedUsers, type, private));
      }
    }

    return shoppingLists;
  }
}