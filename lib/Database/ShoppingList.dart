import 'ShoppingListItem.dart';
import 'User.dart';

class ShoppingList {
  late String name;
  late List<ShoppingListItem> boughtItems;
  late List<ShoppingListItem> items;
  late List<User> assignedUsers;
  late String type; // TODO

  ShoppingList(this.name, this.boughtItems, this.items, this.assignedUsers, this.type);
}