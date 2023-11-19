import 'dart:ui';

import 'Room.dart';
import 'User.dart';

class Problem {
  late String title;
  late String details;
  late List<User> assignedUsers;
  late User author;
  late int priority;
  late List<Image> images;
  late DateTime created;
  late Room room;
}