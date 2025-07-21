class UserModel {
  final String email;
  final String password;
  final String? name;
  final String termosDeUso;
  final String? phone;

  UserModel({
    required this.email,
    required this.password,
    this.name,
    required this.termosDeUso,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'termosDeUso': termosDeUso,
      'phone': phone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      termosDeUso: json['termosDeUso'] as String,
      phone: json['phone'] as String?,
    );
  }
}
