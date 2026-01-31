class ShoppingList {
  String id;
  String name;
  String owner;

  ShoppingList({required this.id, required this.name, required this.owner});

  // Convert ShoppingList to Map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'owner': owner};
  }
}
