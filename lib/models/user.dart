import 'shopping_list.dart';

class UserDetails {
  String id;
  String email;
  String fullName;
  List<ShoppingList> lists = [];

  UserDetails({required this.id, required this.email, required this.fullName});

  Map<String, dynamic> toMap() {
    return {'email': email, 'fullName': fullName, 'lists': lists};
  }

  factory UserDetails.fromMap(String id, Map<String, dynamic> map) {
    return UserDetails(id: id, email: map['email'], fullName: map['fullName']);
  }
}
