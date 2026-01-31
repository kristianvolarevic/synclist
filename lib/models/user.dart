import 'shoppingList.dart';

class User {
  String id;
  String email;
  String fullName;
  List<ShoppingList> lists = [];

  User({required this.id, required this.email, required this.fullName});
}
