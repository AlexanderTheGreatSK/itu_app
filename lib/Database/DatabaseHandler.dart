import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'DataClasses/Room.dart';
import 'DataClasses/ShoppingList.dart';
import 'DataClasses/Task.dart';
import 'DataClasses/User.dart';

class DatabaseHandler {

  bool isMobilePlatform() {
    if(Platform.isIOS || Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }

  // USER end-points--------------------------------------------------------------
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

  // SHOPPING LISTS end-points--------------------------------------------------------------
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

  Future<List<String>> getFavouriteShoppingItems(String categoryName) async {
    List<String> items = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("items").doc(categoryName).get().then((snapshot) {
        var data = snapshot.data();
        for(var item in data!["items"]) {
          items.add(item);
        }
      });
      return items;
    } else {
      // TODO
      return items;
    }
  }

  Future<void> createNewShoppingList(ShoppingList newShoppingList) async {
    List<String> userId = [];

    for(var user in newShoppingList.assignedUsers) {
      userId.add(user.userId);
    }

    if(isMobilePlatform()) {
      final dataMap = <String, dynamic> {
        "name" : newShoppingList.name,
        "private" : newShoppingList.private,
        "type" : newShoppingList.type,
        "items" : newShoppingList.items,
        "boughtItems" : newShoppingList.boughtItems,
        "assignedUsers" : userId,
      };

      if(isMobilePlatform()) {
        await FirebaseFirestore.instance.collection("shoppingLists").doc().set(dataMap).onError((error, stackTrace) => print("Error: $error, $stackTrace"));
      }
    } else {
      // TODO
    }
  }

  Future<void> addItemToShoppingList(String shoppingListName, String newItem) async {
    if(isMobilePlatform()) {
      //await FirebaseFirestore.instance.collection("shoppingLists").where("name", isEqualTo: shoppingListName).u
    } else {
      // TODO
    }
  }

  // ROOMS end-points--------------------------------------------------------------
  Future<void> createRoom(Room newRoom) async {
    if(isMobilePlatform()) {
      final dataMap = <String, dynamic> {
        "name" : newRoom.name,
        "imageId" : newRoom.imageId,
        "progressBar" : newRoom.progressBarValue,
      };

      if(isMobilePlatform()) {
        await FirebaseFirestore.instance.collection("rooms").doc(newRoom.name).set(dataMap).onError((error, stackTrace) => print("Error: $error, $stackTrace"));
      }
    } else {
      // TODO
    }
  }

  // TASKS end-points--------------------------------------------------------------
  Future<void> createTask(Task newTask) async {
    if(isMobilePlatform()) {

      final dataMap = <String, dynamic> {
        "name" : newTask.name,
        "reward" : newTask.reward,
        "days" : newTask.days,
        "priority" : newTask.priority,
        "taskIsDone" : newTask.taskIsDone,
        "room" : newTask.room,
        "lastDone" : newTask.lastDone,
        "targetDate" : newTask.targetDate,
        "assignedUsers" : newTask.assignedUsers,
      };

      if(isMobilePlatform()) {
        DocumentReference documentReference = FirebaseFirestore.instance.collection("tasks").doc();

        documentReference.set(dataMap).then((value) async {
          print(documentReference.id);
          await FirebaseFirestore.instance.collection("rooms").doc(newTask.room).collection("roomTasks").doc(documentReference.id).set(dataMap).onError((error, stackTrace) => print("Error: $error, $stackTrace"));
        }).onError((error, stackTrace) {
          print("Error: $error, $stackTrace");
        });
      }
    } else {
      // TODO
    }
  }

  Future<List<Task>> getTasksForRoom(String roomName) async {
    List<Task> tasks = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("rooms").doc(roomName).collection("roomTasks").get().then((snapshot) {
        for(var docSnapshot in snapshot.docs) {
          var data = docSnapshot.data();

          Timestamp timestamp = data["lastDone"];
          DateTime lastDone = timestamp.toDate();

          timestamp = data["targetDate"];
          DateTime targetDate = timestamp.toDate();

          List<String> userIds = [];

          for(var item in data["assignedUsers"]) {
            userIds.add(item);
          }

          Task task = Task(data["name"], data["reward"], data["days"],
              data["priority"], data["taskIsDone"], data["room"],
              lastDone, targetDate, userIds);

          tasks.add(task);
        }
      });

      return tasks;
    } else {
      // TODO
      return tasks;
    }
  }

  Future<List<Task>> getTaskForUser(String userId) async {
    List<Task> tasks = [];
    if(isMobilePlatform()) {

      await FirebaseFirestore.instance.collection("tasks").where("assignedUsers", arrayContains: userId).get().then((snapshot) {
        for(var docSnapshot in snapshot.docs) {
          var data = docSnapshot.data();

          Timestamp timestamp = data["lastDone"];
          DateTime lastDone = timestamp.toDate();

          timestamp = data["targetDate"];
          DateTime targetDate = timestamp.toDate();

          List<String> userIds = [];

          for(var item in data["assignedUsers"]) {
            userIds.add(item);
          }

          Task task = Task(data["name"], data["reward"], data["days"],
              data["priority"], data["taskIsDone"], data["room"],
              lastDone, targetDate, userIds);

          tasks.add(task);
        }
      });
      return tasks;
    } else {
      // TODO
      return tasks;
    }
  }
}