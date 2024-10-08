/// Authors: Alena Klimecká (xklime47), Jana Kováčiková (xkovac59), Alexander Rastislav Okrucký (xokruc00)

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:itu_app/Database/DataClasses/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/Tasks/CalendarTasksPage.dart';
import 'DataClasses/Room.dart';
import 'DataClasses/ShoppingList.dart';
import 'DataClasses/Task.dart';
import 'DataClasses/User.dart';

class DatabaseHandler {
  /*
  * This class has methods for interactions with our Firestore database
  **/

  /*
  * Author: Alexander Rastislav Okrucký (xokruc00)
  *
  * This method checks if actual platform is iOS or Android
  **/
  bool isMobilePlatform() {
    if (Platform.isIOS || Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }

  // LOCAL USER end-points--------------------------------------------------------------
  /*
  * Author: Alexander Rastislav Okrucký (xokruc00)
  *
  * This section
  **/
  Future<void> safeUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userId", userId);
  }

  Future<String> getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("userId")!;
    return userId;
  }

  Future<OurUser> getCurrentUser() async {
    String userId = await getCurrentUserId();
    OurUser user = await getUserById(userId);
    return user;
  }

  Future<bool> isUserSaved() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey("userId");
  }

  // USER end-points--------------------------------------------------------------
  Future<void> createNewUser(OurUser user) async {
    final userMap = <String, dynamic>{
      "username": user.username,
      "profilePicture": user.profilePicture,
      "points": user.points,
      "userId": user.userId,
    };

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.userId)
          .set(userMap)
          .onError((error, stackTrace) => print("Error: $error, $stackTrace"));
    }
  }

  Future<bool> userExists(String userId) async {
    bool exists = false;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((snapshot) {
      exists = snapshot.exists;
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
    return exists;
  }

  Future<List<OurUser>> getUsers() async {
    List<OurUser> users = [];

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("users")
          .get()
          .then((snapshot) {
        var docsMap = snapshot.docs;
        for (var item in docsMap) {
          var data = item.data();
          users.add(OurUser(data["username"], data["userId"],
              data["profilePicture"], data["points"]));
        }
      });
      return users;
    } else {
      Uri uri = Uri.https("firestore.googleapis.com",
          "v1/projects/nashhouse-6656c/databases/(default)/documents/users");
      var response = await http.get(uri);
      Map data = json.decode(response.body);
      for (var item in data["documents"]) {
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

  Future<List<OurUser>> getLeaderBoardUsers() async {
    List<OurUser> users = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("users").orderBy("points", descending: true).limit(3).get().then((snapshot) {
        var docsMap = snapshot.docs;
        for(var item in docsMap) {
          print(item.data());
          var data = item.data();
          users.add(OurUser(data["username"], data["userId"], data["profilePicture"], data["points"]));
        }
      });
      return users;
    } else {
      return users;
    }
  }

  Future<OurUser> getUserById(String userId) async {
    OurUser user;

    if (isMobilePlatform()) {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      print(snapshot.data());
      return OurUser(snapshot.data()?["username"], snapshot.data()?["userId"],
          snapshot.data()?["profilePicture"], snapshot.data()?["points"]);
    } else {
      Uri uri = Uri.https("firestore.googleapis.com",
          "v1/projects/nashhouse-6656c/databases/(default)/documents/users/$userId");
      var response = await http.get(uri);
      Map body = jsonDecode(response.body);
      body = body["fields"];
      user = OurUser(
          body["username"]["stringValue"],
          body["userId"]["stringValue"],
          body["profilePicture"]["stringValue"],
          int.parse(body["points"]["integerValue"]));
      return user;
    }
  }

  // SHOPPING LISTS end-points--------------------------------------------------------------
  Future<List<ShoppingList>> getShoppingLists(bool isPrivate) async {
    List<ShoppingList> shoppingLists = [];

    String userId = await getCurrentUserId();

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("shoppingLists")
          .where("assignedUsers", arrayContains: userId)
          .where("private", isEqualTo: isPrivate)
          .get()
          .then((snapshot) async {
        var docsMap = snapshot.docs;
        for (var item in docsMap) {
          List<String> boughtItems = [];
          List<String> items = [];
          List<OurUser> assignedUsers = [];

          for (var bItem in item.data()["boughtItems"]) {
            boughtItems.add(bItem);
          }
          for (var nItem in item.data()["items"]) {
            items.add(nItem);
          }

          for (var user in item.data()["assignedUsers"]) {
            OurUser? ourUser = await getUserById(user);
            if (ourUser != null) {
              assignedUsers.add(ourUser);
            }
          }
          String shoppingListId = item.data()["shoppingListId"];
          String name = item.data()["name"];
          String type = item.data()["type"];
          bool private = item.data()["private"];
          shoppingLists.add(ShoppingList(shoppingListId, name, boughtItems,
              items, assignedUsers, type, private));
        }
      });
    } else {
      Uri uri = Uri.https("firestore.googleapis.com",
          "v1/projects/nashhouse-6656c/databases/(default)/documents/shoppingLists");
      var response = await http.get(uri);
      Map data = json.decode(response.body);
      for (var item in data["documents"]) {
        var fields = item["fields"];
        String shoppingListId = fields["shoppingListId"]["stringValue"];
        String name = fields["name"]["stringValue"];
        String type = fields["type"]["stringValue"];
        bool private = fields["private"]["booleanValue"];
        List<String> items = [];
        List<String> boughtItems = [];
        List<OurUser> assignedUsers = [];

        if (private == isPrivate) {
          var rawItems = fields["items"]["arrayValue"]["values"];
          for (var item in rawItems) {
            items.add(item["stringValue"]);
          }
          var rawBoughtItems = fields["boughtItems"]["arrayValue"];
          if (rawBoughtItems.isNotEmpty) {
            rawBoughtItems = rawBoughtItems["values"];
            for (var item in rawBoughtItems) {
              boughtItems.add(item["stringValue"]);
            }
          }

          var rawUsers = fields["assignedUsers"]["arrayValue"];
          if (rawUsers.isNotEmpty) {
            rawUsers = rawUsers["values"];
            for (var item in rawUsers) {
              assignedUsers.add(await getUserById(item["stringValue"]));
            }
          }

          shoppingLists.add(ShoppingList(shoppingListId, name, boughtItems,
              items, assignedUsers, type, private));
        }
      }
    }

    return shoppingLists;
  }

  Future<ShoppingList> getShoppingListByID(String shoppingListId) async {
    ShoppingList shoppingList = ShoppingList.empty();

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("shoppingLists")
          .doc(shoppingListId)
          .get()
          .then((snapshot) async {
        var data = snapshot.data();

        List<String> boughtItems = [];
        List<String> items = [];
        List<OurUser> assignedUsers = [];

        for (var bItem in data!["boughtItems"]) {
          boughtItems.add(bItem);
        }
        for (var nItem in data["items"]) {
          items.add(nItem);
        }

        for (var user in data["assignedUsers"]) {
          OurUser? ourUser = await getUserById(user);
          if (ourUser != null) {
            assignedUsers.add(ourUser);
          }
        }
        String shoppingListId = data["shoppingListId"];
        String name = data["name"];
        String type = data["type"];
        bool private = data["private"];
        shoppingList = ShoppingList(shoppingListId, name, boughtItems, items,
            assignedUsers, type, private);
      });
      return shoppingList;
    } else {
      // TODO
      return shoppingList; // TODO
    }
  }

  Future<List<String>> getFavouriteShoppingItems(String categoryName) async {
    List<String> items = [];

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("items")
          .doc(categoryName)
          .get()
          .then((snapshot) {
        var data = snapshot.data();
        for (var item in data!["items"]) {
          items.add(item);
        }
      });
      return items;
    } else {
      // TODO
      return items;
    }
  }

  Stream<QuerySnapshot>? getShoppingListsUpdate(bool isPrivate, String userId) {
    print("Received: $userId");
    return FirebaseFirestore.instance
        .collection("shoppingLists")
        .where("assignedUsers", arrayContains: userId)
        .where("private", isEqualTo: isPrivate)
        .snapshots();
    /*getCurrentUserId().then((userId) {
      print("USUSUSUSU:$userId");
      return FirebaseFirestore.instance.collection("shoppingLists").where("assignedUsers", arrayContains: userId).where("private", isEqualTo: isPrivate).snapshots();
    });
    print("hahaha");*/
  }

  Future<ShoppingList> createNewShoppingList(
      ShoppingList newShoppingList) async {
    List<String> userId = [];

    for (var user in newShoppingList.assignedUsers) {
      userId.add(user.userId);
    }

    if (isMobilePlatform()) {
      var ref = FirebaseFirestore.instance.collection("shoppingLists").doc();
      String shoppingListId = ref.id;

      final dataMap = <String, dynamic>{
        "name": newShoppingList.name,
        "private": newShoppingList.private,
        "type": newShoppingList.type,
        "items": newShoppingList.items,
        "boughtItems": newShoppingList.boughtItems,
        "assignedUsers": userId,
        "shoppingListId": shoppingListId,
      };

      await ref
          .set(dataMap)
          .onError((error, stackTrace) => print("Error: $error, $stackTrace"));

      newShoppingList.shoppingListId = shoppingListId;
      return newShoppingList;
    } else {
      return newShoppingList; // TODO
    }
  }

  Future<void> addItemToShoppingList(
      String shoppingListId, String newItem) async {
    if (isMobilePlatform()) {
      FirebaseFirestore.instance
          .collection("shoppingLists")
          .doc(shoppingListId)
          .update({
        "items": FieldValue.arrayUnion([newItem])
      });
    } else {
      // TODO
    }
  }

  /*
  * if bought is true, item will be removed from items and added to boughtItems
  *
  * if bought is false, item will be removed from boughtItems to items
  *
  * */
  Future<void> setItemAsBought(
      String shoppingListId, String itemName, bool bought) async {
    if (isMobilePlatform()) {
      if (bought) {
        FirebaseFirestore.instance
            .collection("shoppingLists")
            .doc(shoppingListId)
            .update({
          "items": FieldValue.arrayRemove([itemName]),
          "boughtItems": FieldValue.arrayUnion([itemName]),
        });
      } else {
        FirebaseFirestore.instance
            .collection("shoppingLists")
            .doc(shoppingListId)
            .update({
          "boughtItems": FieldValue.arrayRemove([itemName]),
          "items": FieldValue.arrayUnion([itemName]),
        });
      }
    } else {
      // TODO
    }
  }

  Future<void> deleteItem(
      String shoppingListId, String itemName, bool bought) async {
    if (isMobilePlatform()) {
      if (bought) {
        FirebaseFirestore.instance
            .collection("shoppingLists")
            .doc(shoppingListId)
            .update({
          "boughtItems": FieldValue.arrayRemove([itemName]),
        });
      } else {
        FirebaseFirestore.instance
            .collection("shoppingLists")
            .doc(shoppingListId)
            .update({
          "items": FieldValue.arrayRemove([itemName]),
        });
      }
    } else {}
  }

  Future<void> deleteShoppingList(String shoppingListId) async {
    if (isMobilePlatform()) {
      FirebaseFirestore.instance
          .collection("shoppingLists")
          .doc(shoppingListId)
          .delete();
    }
  }

  Future<void> updateShoppingList(ShoppingList newShoppingList) async {
    List<String> userId = [];

    for (var user in newShoppingList.assignedUsers) {
      userId.add(user.userId);
    }

    if (isMobilePlatform()) {
      final dataMap = <String, dynamic>{
        "name": newShoppingList.name,
        "private": newShoppingList.private,
        "type": newShoppingList.type,
        "items": newShoppingList.items,
        "boughtItems": newShoppingList.boughtItems,
        "assignedUsers": userId,
      };

      FirebaseFirestore.instance
          .collection("shoppingLists")
          .doc(newShoppingList.shoppingListId)
          .update(dataMap);
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "152393665335-pnvkvg510fudheejggp66niaecfh8210.apps.googleusercontent.com",
    scopes: <String>[
      "https://www.googleapis.com/auth/calendar",
    ],
  );

  Future<void> addTaskToCalendar(Task task) async {
    GoogleAPI.Event event = GoogleAPI.Event();

    event.summary = task.name;

    GoogleAPI.EventDateTime start = GoogleAPI.EventDateTime();
    start.date = task.targetDate;

    GoogleAPI.EventDateTime end = GoogleAPI.EventDateTime();
    end.date = task.targetDate;

    event.start = start;
    event.end = end;
    String eD = DateFormat('dd.MM.yyyy').format(task.targetDate);
    final dataMap = <String, dynamic> {
      "end": {
        "date": eD,
      },
      "start": {
        "date": eD,
      },
      "summary": task.name
    };

    /*await _googleSignIn.signIn();
    final token = (await _googleSignIn.currentUser!.authentication).accessToken;*/



    /*http.Response response = await http.post(
      Uri.parse("https://www.googleapis.com/calendar/v3/calendars/primary/events?maxAttendees=1&sendNotifications=true&sendUpdates=none&key=$token"),
      headers: <String, String>{
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataMap)
    );

    print(response.body);*/


    await _googleSignIn.signIn();
    //final headers = await _googleSignIn.currentUser!.authHeaders;
    var user = _googleSignIn.currentUser!;
    final httpClient = GoogleAPIClient(await user.authHeaders);
    final GoogleAPI.CalendarApi calendarAPI = GoogleAPI.CalendarApi(httpClient);

    await calendarAPI.events.insert(event,"primary", conferenceDataVersion: 0, maxAttendees: 1, sendNotifications: true, sendUpdates: null, supportsAttachments: false).then((value) {
      print(value.status);
    });
  }

  // ROOMS end-points--------------------------------------------------------------
  Future<void> createRoom(Room newRoom) async {
    if (isMobilePlatform()) {
      final dataMap = <String, dynamic>{
        "name": newRoom.name,
        "imageId": newRoom.imageId,
        "progressBar": newRoom.progressBarValue,
      };

      if (isMobilePlatform()) {
        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(newRoom.name)
            .set(dataMap)
            .onError(
                (error, stackTrace) => print("Error: $error, $stackTrace"));
      }
    } else {
      // TODO
    }
  }

  Future<List<Room>> getRooms() async {
    List<Room> rooms = [];

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("rooms")
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          var data = doc.data();
          rooms.add(Room(data["name"], data["imageId"], data["progressBar"]));
        }
      });
      return rooms;
    } else {
      Uri uri = Uri.https("firestore.googleapis.com",
          "v1/projects/nashhouse-6656c/databases/(default)/documents/rooms");
      var response = await http.get(uri);
      Map data = json.decode(response.body);
      for (var item in data["documents"]) {
        var fields = item["fields"];
        print(fields);
        String name = fields["name"]["stringValue"];
        String imageId = fields["imageId"]["stringValue"];
        int progressBar = int.parse(fields["progressBar"]["integerValue"]);

        rooms.add(Room(name, imageId, progressBar));
      }
      return rooms;
    }
  }
  
  Future<double> updateRoomStatusBar(String roomId) async {
    var snapshot = await FirebaseFirestore.instance.collection("rooms").doc(roomId).collection("roomTasks").count().get();
    int allTasks = snapshot.count;
    print("ALL TASKS: $allTasks");
    if(allTasks == 0) {
      return -1.0;
    }

    snapshot = await FirebaseFirestore.instance.collection("rooms").doc(roomId).collection("roomTasks").where("taskIsDone", isEqualTo: true).count().get();
    int doneTasks = snapshot.count;
    print("DONE TASKS: $doneTasks");
    double percentage = (doneTasks * 100) / allTasks;

    FirebaseFirestore.instance.collection("rooms").doc(roomId).update({"progressBar": percentage.round()});
    return percentage;
  }

  // TASKS end-points--------------------------------------------------------------
  Future<void> createTask(Task newTask) async {

    if(isMobilePlatform()) {

      DocumentReference documentReference = FirebaseFirestore.instance.collection("tasks").doc();

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
        "taskId" : documentReference.id,
      };




        documentReference.set(dataMap).then((value) async {
          print(documentReference.id);
          await FirebaseFirestore.instance
              .collection("rooms")
              .doc(newTask.room)
              .collection("roomTasks")
              .doc(documentReference.id)
              .set(dataMap)
              .onError(
                  (error, stackTrace) => print("Error: $error, $stackTrace"));
        }).onError((error, stackTrace) {
          print("Error: $error, $stackTrace");
        });

    } else {
      // TODO
    }
  }

  Future<List<Task>> getTasksForRoom(String roomName) async {
    List<Task> tasks = [];

    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomName)
          .collection("roomTasks")
          .where("taskIsDone", isEqualTo: false)
          .get()
          .then((snapshot) {
        for (var docSnapshot in snapshot.docs) {
          var data = docSnapshot.data();

          Timestamp timestamp = data["lastDone"];
          DateTime lastDone = timestamp.toDate();

          timestamp = data["targetDate"];
          DateTime targetDate = timestamp.toDate();

          List<String> userIds = [];

          for (var item in data["assignedUsers"]) {
            userIds.add(item);
          }


          Task task = Task(data["name"], data["reward"], data["days"],
              data["priority"], data["taskIsDone"], data["room"],
              lastDone, targetDate, userIds, data["taskId"]);


          tasks.add(task);
        }
      });

      return tasks;
    } else {
      // TODO
      return tasks;
    }
  }

  Future<List<Task>> getTaskForUserToday() async {
    String userId = await getCurrentUserId();
    DateTime today = DateTime.now();

    List<Task> tasks = [];
    if (isMobilePlatform()) {
      await FirebaseFirestore.instance
          .collection("tasks")
          .orderBy('targetDate')
          .where('taskIsDone', isEqualTo: false)
          .startAt([DateTime(today.year, today.month, today.day)])
          .endAt([DateTime(today.year, today.month, today.day, 23, 59, 59)])
          .where("assignedUsers", arrayContains: userId).get().then((snapshot) {
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
              lastDone, targetDate, userIds, data["taskId"]);

          tasks.add(task);
        }
      });

      return tasks;
    } else {
      // TODO
      return tasks;
    }
  }

  Future<List<Task>> getTaskForUserWeek() async {
    String userId = await getCurrentUserId();
    DateTime today = DateTime.now();
    int weekDay = today.weekday;

    DateTime startDate =
        DateTime(today.year, today.month, today.day - (weekDay - 1));
    DateTime endDate =
        DateTime(today.year, today.month, today.day + (7 - weekDay));

    print("START: ${startDate.toString()}");
    print("END: ${endDate.toString()}");

    List<Task> tasks = [];

    if(isMobilePlatform()) {

      await FirebaseFirestore.instance.collection("tasks")
          .where('taskIsDone', isEqualTo: false)
          .orderBy('targetDate')
          .startAt([DateTime(startDate.year, startDate.month, startDate.day)])
          .endAt([DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)])
          .where("assignedUsers", arrayContains: userId).get().then((snapshot) {
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
              lastDone, targetDate, userIds, data["taskId"]);

          tasks.add(task);
        }
      });
      return tasks;
    } else {
      // TODO
      return tasks;
    }
  }

  Future<void> deleteTask(Task task) async {
    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("rooms").doc(task.room).collection("roomTasks").doc(task.taskId).delete();
      await FirebaseFirestore.instance.collection("tasks").doc(task.taskId).delete();
    } else {

    }
  }

// REWARDS end-points--------------------------------------------------------------
  Future<void> createReward(Reward newReward) async {
    if(isMobilePlatform()) {
      DocumentReference documentReference = FirebaseFirestore.instance.collection("rewards").doc();

      final dataMap = <String, dynamic> {
        "name" : newReward.name,
        "price" : newReward.price,
        "imageId" : newReward.imageId,
        "isAvailable" : newReward.isAvailable,
        "rewardId" : documentReference.id,
      };

      print(dataMap.toString());

      await FirebaseFirestore.instance.collection("rewards").doc().set(dataMap).onError((error, stackTrace) => print("Error: $error, $stackTrace"));

    } else {
      // TODO
    }
  }

  Future<void> taskIsDone(Task task) async {
    if(isMobilePlatform()) {
      String userId = await getCurrentUserId();

      DateTime today = DateTime.now();

      DateTime targetDate = DateTime(today.year, today.month, today.day + task.days);

      final taskUpdate = <String, dynamic> {
        "taskIsDone" : true,
        "lastDone" : today,
        "targetDate" : targetDate,
      };

      FirebaseFirestore.instance.collection("tasks").doc(task.taskId).update(taskUpdate);
      FirebaseFirestore.instance.collection("rooms").doc(task.room).collection("roomTasks").doc(task.taskId).update(taskUpdate);

      updateUserPoints(userId, task.reward);
    }
  }

  Future<void> updateUserPoints(String userId, int points) async {
    if(isMobilePlatform()) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      var data = snapshot.data() as Map<String, dynamic>;

      int oldPoints = data["points"];
      int newPoints = oldPoints + points;

      FirebaseFirestore.instance.collection("users").doc(userId).update({"points": newPoints});
    }
  }

  Future<List<Reward>> getRewards() async {
    List<Reward> rewards = [];

    if(isMobilePlatform()) {
      await FirebaseFirestore.instance.collection("rewards").where("isAvailable", isEqualTo: true).get().then((snapshot) {
        print(snapshot.size);
        for(var docSnapshot in snapshot.docs) {
          var data = docSnapshot.data();
          print(data);
          rewards.add(Reward(data["name"], data["price"], data["imageId"], data["isAvailable"], data["rewardId"]));
        }
        return rewards;
      });
    } else {
      return rewards;
    }
    return rewards;
  }

  Future<void> buyReward(Reward reward) async {
    if (isMobilePlatform()) {
      var ref = FirebaseFirestore.instance.collection("rewards").doc(reward.rewardId);

      await ref
          .set({"isAvailable": false})
          .onError((error, stackTrace) => print("Error: $error, $stackTrace"));
    }
  }

}

