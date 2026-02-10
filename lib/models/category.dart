class Category {
  String id;
  String name;

  Category({required this.id, required this.name});

  // Convert Category to Map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  // Create Category from Firestore Map
  factory Category.fromMap(String id, Map<String, dynamic> map) {
    return Category(id: id, name: map['name']);
  }
}
