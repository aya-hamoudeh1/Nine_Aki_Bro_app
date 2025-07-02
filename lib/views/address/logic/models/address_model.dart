class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String? state;
  final String? postalCode;
  final String country;
  final DateTime? createdAt;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    required this.country,
    this.createdAt,
    this.isDefault = false,
  });

  String get formattedAddress {
    final addressParts = [
      street,
      city,
      if (state != null && state!.isNotEmpty) state,
      if (postalCode != null && postalCode!.isNotEmpty) postalCode,
      country,
    ];
    return addressParts.join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isDefault: json['is_default'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'is_default': isDefault,
    };
  }
}
