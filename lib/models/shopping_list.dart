class ShoppingList {
  String id;
  String name;
  String owner;
  List<String> joinedUsers;
  String code;
  bool isShared;
  bool automaticDeletion;

  ShoppingList({
    required this.id,
    required this.name,
    required this.owner,
    this.joinedUsers = const [],
    this.code = '',
    this.isShared = false,
    this.automaticDeletion = false,
  });

  // Convert ShoppingList to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner': owner,
      'joinedUsers': joinedUsers,
      'code': code,
      'isShared': isShared,
      'automaticDeletion': automaticDeletion,
    };
  }

  // Create ShoppingList from Firestore Map
  factory ShoppingList.fromMap(String id, Map<String, dynamic> map) {
    return ShoppingList(
      id: id,
      // Use ?? to provide empty strings if the fields don't exist
      name: map['name'] ?? 'Unnamed List',
      owner: map['owner'] ?? '',
      // Cast the list to String safely
      joinedUsers: List<String>.from(map['joinedUsers'] ?? []),
      code: map['shareCode'] ?? '',
      isShared: map['isShared'] ?? false,
      automaticDeletion: map['automaticDeletion'] ?? false,
    );
  }
}
