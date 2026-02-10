import 'package:household_groceries/models/category.dart';

class ShoppingList {
  String id;
  String name;
  String owner;
  List<String> categoryIds;

  ShoppingList({
    required this.id,
    required this.name,
    required this.owner,
    this.categoryIds = const [],
  });

  // Convert ShoppingList to Map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'owner': owner, 'categoryIds': categoryIds};
  }

  // Create ShoppingList from Firestore Map
  factory ShoppingList.fromMap(String id, Map<String, dynamic> map) {
    return ShoppingList(
      id: id,
      name: map['name'],
      owner: map['owner'],
      categoryIds: List<String>.from(map['categoryIds'] ?? []),
    );
  }
}
