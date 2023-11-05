import 'package:hive/hive.dart';
import 'myEnum.dart';

part "RoomType.g.dart";



@HiveType(typeId: 0)
class RoomClass {
  @HiveField(0)
  late String name;

  RoomClass(this.name);
}