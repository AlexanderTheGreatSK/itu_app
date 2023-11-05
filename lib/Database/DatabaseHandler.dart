import 'package:hive/hive.dart';

class DatabaseHandler {
  Future<void> addNewRoom(String roomName) async {
    await Hive.box("rooms").add(roomName);
  }
}