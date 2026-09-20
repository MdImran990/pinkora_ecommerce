class AddressModel {
  final String id;

  /// Home, Office or Other
  final String label;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? label,
    String? name,
    String? phone,
    String? address,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id,
      label: label ?? this.label,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'name': name,
    'phone': phone,
    'address': address,
    'isDefault': isDefault,
  };

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Home',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }
}
