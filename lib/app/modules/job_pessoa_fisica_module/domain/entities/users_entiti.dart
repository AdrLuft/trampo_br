class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profileImageUrl;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl,
  });
  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
