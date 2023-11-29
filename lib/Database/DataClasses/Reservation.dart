import 'Room.dart';
import 'User.dart';

class Reservation {
  late String name;
  late DateTime start;
  late DateTime end;
  late User author;
  late Room room;

  Reservation(this.name, this.start, this.end, this.author, this.room);
}