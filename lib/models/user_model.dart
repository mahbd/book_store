class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;
  final bool isAdmin;
  final String? accessToken;
  final String? refreshToken;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.isAdmin,
    this.accessToken,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['pk'],
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      image: json['image'],
      isAdmin: json['is_superuser'] ?? false,
    );
  }
}
