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
  late List<String> assignedUsers;
  late String taskId;

  Task(this.name, this.reward, this.days, this.priority, this.taskIsDone, this.room, this.lastDone, this.targetDate, this.assignedUsers, this.taskId);

  void debugPrint() {
    print("Task name: $name");
    print("Task reward: $reward");
    print("Task days: $days");
    print("Task priority: $priority");
    print("Task isDone: $taskIsDone");
    print("Task room: $room");
    print("Task lastDone: $lastDone");
    print("Task targetDate: $targetDate");
    print("Task id: $taskId");

    print("Assigned users:");
    for(var userId in assignedUsers) {
      print(userId);
    }
  }
}