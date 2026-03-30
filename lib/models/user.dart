class UserDetails {
  String id;
  String email;
  String fullName;
  List<String> lists = [];

  UserDetails({required this.id, required this.email, required this.fullName});

  Map<String, dynamic> toMap() {
    return {'email': email, 'fullName': fullName, 'lists': lists};
  }

  factory UserDetails.fromMap(String id, Map<String, dynamic> map) {
    final user = UserDetails(
      id: id,
      email: map['email'],
      fullName: map['fullName'],
    );

    user.lists = List<String>.from(map['lists'] ?? []);

    return user;
  }
}
