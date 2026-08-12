class User {
  final String name;
  final String email;
  final String id;
  final String token;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      id: (json['id'] as int).toString(),
      token: json['token'] as String,
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() =>
      "User(id: $id, name: $name, email: $email, token: $token)";
}
