class UserModel {
  final String email;
  final String password;
  final String? name;
  final String termosDeUso;

  UserModel({
    required this.email,
    required this.password,
    this.name,
    required this.termosDeUso,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'termosDeUso': termosDeUso,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      termosDeUso: json['termosDeUso'] as String,
    );
  }
}
