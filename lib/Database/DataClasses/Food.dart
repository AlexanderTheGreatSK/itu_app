import 'dart:ui';

import 'User.dart';

class Food {
  late String name;
  late List<User> assignedUsers;
  late bool private;
  late Image image;
  late DateTime endDate;
  late DateTime createdDate;

  Food(this.name, this.assignedUsers, this.private, this.image, this.endDate, this.createdDate);
}