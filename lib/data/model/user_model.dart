class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatar = '',
    this.address = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    avatar: json['avatar'] ?? '',
    address: json['address'] ?? '',
  );
}