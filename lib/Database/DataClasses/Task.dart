import 'User.dart';

class Task {
  late String name;
  late int reward;
  late int days;
  late int priority;
  late bool taskIsDone;
  late String room;
  late DateTime lastDone;
  late DateTime targetDate;
  late List<OurUser> assignedUsers;

  Task(this.name, this.reward, this.days, this.priority, this.taskIsDone, this.room, this.lastDone, this.targetDate, this.assignedUsers);
}