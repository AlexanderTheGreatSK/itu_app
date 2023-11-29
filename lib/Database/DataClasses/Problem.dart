import 'dart:ui';

import 'Room.dart';
import 'User.dart';

class Problem {
  late String title;
  late String details;
  late List<OurUser> assignedUsers;
  late OurUser author;
  late int priority;
  late List<Image> images;
  late DateTime created;
  late Room room;

  Problem(this.title, this.details, this.assignedUsers, this.author, this.priority, this.images, this.created, this.room);
}