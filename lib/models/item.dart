class Item {
  String id;
  String name;
  String categoryId;
  bool isCollected;
  bool isQuantityBased;
  int quantity;
  double weight;

  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    this.isCollected = false,
    this.isQuantityBased = true,
    this.quantity = 1,
    this.weight = 0.0,
  });

  // Convert Item to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'isCollected': isCollected,
      'isQuantityBased': isQuantityBased,
      'quantity': quantity,
      'weight': weight,
    };
  }

  // Create Item from Firestore Map
  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      id: id,
      name: map['name'],
      categoryId: map['categoryId'],
      isCollected: map['isCollected'] ?? false,
      isQuantityBased: map['isQuantityBased'] ?? true,
      quantity: map['quantity'] ?? 1,
      weight: (map['weight'] ?? 0.0).toDouble(),
    );
  }
}
