import 'User.dart';

class ShoppingList {
  late String name;
  late List<String> boughtItems;
  late List<String> items;
  late List<OurUser> assignedUsers;
  late String type;
  late bool private;

  ShoppingList(this.name, this.boughtItems, this.items, this.assignedUsers, this.type, this.private);

  void debugPrint() {
    print("Name: $name");
    print("Type: $type");
    print("Private: $private");
    print("Bought items: ${boughtItems.toString()}");
    print("Items: ${items.toString()}");
    print("Assigned users:");

    int index = 0;
    for(OurUser user in assignedUsers) {
      print("User number $index --------");
      user.debugPrint();
      index++;
    }
  }
}