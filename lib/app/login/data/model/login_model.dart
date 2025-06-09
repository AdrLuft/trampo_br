class UserModel {
  final String email;
  final String password;
  final String? name;

  UserModel({required this.email, required this.password, this.name});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
}
