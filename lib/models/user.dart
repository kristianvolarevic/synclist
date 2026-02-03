import 'shoppingList.dart';

class UserDetails {
  String id;
  String email;
  String fullName;
  List<ShoppingList> lists = [];

  UserDetails({required this.id, required this.email, required this.fullName});

  factory UserDetails.fromMap(String id, Map<String, dynamic> map) {
    return UserDetails(id: id, email: map['email'], fullName: map['fullName']);
  }
}
