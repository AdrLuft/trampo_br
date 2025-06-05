class LoginModel {
  final String email;
  final String password;
  final String? name;

  LoginModel({required this.email, required this.password, this.name});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
}
