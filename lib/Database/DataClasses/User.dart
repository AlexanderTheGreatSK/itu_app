import 'dart:ui';

class OurUser {
  late String username;
  late String userId;
  late String profilePicture;
  late int points;

  OurUser(this.username, this.userId, this.profilePicture, this.points);

  void debugPrint() {
    print("Username: $username");
    print("UserID: $userId");
    print("Points: $points");
  }
}